module Web.Controller.Room where

import Web.Controller.Prelude
import Web.View.Room.Show
import Database.PostgreSQL.Simple (Query)
import Database.PostgreSQL.Simple.FromRow (field, fromRow)
import qualified Data.Char as Char
import qualified Data.Text as Text
import System.Random (randomIO)


data MessageRow = MessageRow {
      createdAt :: !UTCTime
    , sender :: !Text
    , isFinal :: !Bool
    , words :: !Text
    , row :: !Int
}

instance FromRow MessageRow where
    fromRow =
        MessageRow
            <$> field
            <*> field
            <*> field
            <*> field
            <*> field

instance Controller RoomController where
    action ShowRoomAction = autoRefresh do
        participantName <- getSession "participantName"
        case participantName of
            Just self -> do
                messageRows <- fetchMessageRows
                let senders = buildSender <$> messageRows
                render ShowView {..}
            Nothing -> redirectTo NewParticipantAction

    action CreateMessageAction = do
        cleanGarbage
        newRecord @Message |> buildMessage |> createRecord
        renderPlain "ok"

cleanGarbage :: (?modelContext :: ModelContext) => IO ()
cleanGarbage = do
    number <- randomIO @Int
    if number `mod` 20 == 0 then cleanGarbage' else pure ()

cleanGarbage' :: (?modelContext :: ModelContext) => IO ()
cleanGarbage' =
    sqlExec "delete from messages where created_at < now() - interval '5 minutes'" () >> pure ()

buildSender :: MessageRow -> Sender
buildSender messageRow =
    Sender {
          name = get #sender messageRow
        , isFinal = get #isFinal messageRow
        , words = get #words messageRow
    }

buildMessage :: (?context :: ControllerContext) => Message -> Message
buildMessage message = 
    let words = param @Text "words" |> capitalized in
        message 
            |> fill @'["sender", "isFinal"] 
            |> set #words words

capitalized :: Text -> Text
capitalized text = text |> Text.strip |> Text.unpack |> capitalized' |> Text.pack

capitalized' :: String -> String
capitalized' (head:tail) = Char.toUpper head : tail
capitalized' [] = []

fetchMessageRows :: (?modelContext :: ModelContext) => IO [MessageRow]
fetchMessageRows = do
    trackTableRead "messages"
    sqlQuery messageRowsQuery ()

messageRowsQuery :: Query
messageRowsQuery = "with ranked_messages as (select created_at, sender, is_final, words, row_number() over (partition by sender order by created_at desc) as rn from messages) select * from ranked_messages where rn = 1 order by created_at desc;"