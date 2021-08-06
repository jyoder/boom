module Web.Controller.Participants where

import Web.Controller.Prelude
import Web.View.Participants.New
import qualified Data.Text as Text

instance Controller ParticipantsController where
    action NewParticipantAction = do
        render NewView { error = Nothing }

    action CreateParticipantAction = do
        let name = param "name" |> Text.strip
        if name /= ""
            then do
                setSession "participantName" name
                redirectTo ShowRoomAction
            else
                render NewView { error = "Your name cannot be blank." }
