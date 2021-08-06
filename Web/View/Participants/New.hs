module Web.View.Participants.New where
import Web.View.Prelude

newtype NewView = NewView { error :: Maybe Text }

instance View NewView where
    html NewView {..} = [hsx|
        <div class="container mt-3">
            <h3 class="text-center mb-5">Silent Zoom</h3>
            <div class="d-flex justify-content-center">
                {renderNameForm error}
            </div>
        </div>
    |]

renderNameForm :: Maybe Text -> Html
renderNameForm error = [hsx|
    <form method="POST" action={CreateParticipantAction} class="edit-form" data-disable-javascript-submission="false">
        <div class="form-group">
            <label for="name" class="display-4 d-flex justify-content-center">What is your name?</label><br>
            <input type="text" class={"form-control form-control-lg d-flex justify-content-center " <> errorClass error} name="name" value="" maxlength="50" autocomplete="off">
            <div class="invalid-feedback">{fromMaybe "" error}</div>
        </div>
        <button type="submit" class="btn btn-primary btn-lg d-flex justify-content-center">Join</button>
    </form>
|]

errorClass :: Maybe Text -> Text
errorClass error =
    case error of
        Just error -> "is-invalid"
        Nothing -> "" 
