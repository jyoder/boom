module Web.View.Room.Show where
import Web.View.Prelude

data ShowView = ShowView {
      self :: !Text
    , presenter :: !(Maybe Sender)
    , senders :: [Sender]
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
                <h3 class="text-center mb-5">Silent Zoom</h3>
                <div class="row">
                    <div class="col pr-4">
                        {forEach senders renderSender}
                        <div id="url" style="display: none;">{urlTo $ CreateMessageAction}</div>
                        <div id="sender" style="display: none;">{self}</div>
                    </div>
                    {renderPresenter presenter}
                </div>
            </div>
        </main>
    |]

renderSender :: Sender -> Html
renderSender sender =
    [hsx|
        <div class="card mb-2" style="width: 500px;">
            <div class="card-body">
                <h5 class="card-title">{get #name sender}</h5>
                <p class={wordsClass sender}>{get #words sender}</p>
            </div>
        </div>
    |]

wordsClass :: Sender -> Text
wordsClass sender =
    if get #isFinal sender
        then ""
        else "text-secondary"

renderPresenter :: Maybe Sender -> Html
renderPresenter (Just sender) =
    [hsx|
        <div class="pt-5" style="text-align: center; width: 600px;">
            <h3 class="pb-5">{get #name sender}</h3>
            <p class={wordsClass sender}>{get #words sender}</p>
        </div>
    |]
renderPresenter Nothing =
    [hsx|
        <div class="pt-5" style="text-align: center; width: 600px;">
            <h3 class="pb-5">No Presenter</h3>
        </div>
    |]