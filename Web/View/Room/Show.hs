module Web.View.Room.Show where
import Web.View.Prelude

newtype ShowView = ShowView {
    senders :: [Sender]
}

data Sender = Sender {
      name :: !Text
    , isFinal :: !Bool
    , words :: !Text
}

instance View ShowView where
    html ShowView {..} = [hsx|
        <main>
            <div class="container mt-3">
                <h3 class="text-center mb-5">Boom</h3>
                {forEach senders renderSender}
                <div id="url" style="display: none;">{urlTo $ CreateMessageAction}</div>
            </div>
        </main>
    |]

renderSender :: Sender -> Html
renderSender sender =
    [hsx|
        <div class="list-group">
            <div class="list-group-item">
                <div class="d-flex w-100 justify-content-between mb-2">
                    <h5>{get #name sender}</h5>
                </div>
                <p class={"mb-2 " <> wordsClass sender}>{get #words sender}</p>
            </div>
        </div>
    |]

wordsClass :: Sender -> Text
wordsClass sender =
    if get #isFinal sender
        then ""
        else "text-secondary"