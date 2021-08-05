module Web.View.Room.Show where
import Web.View.Prelude

data ShowView = ShowView

instance View ShowView where
    html ShowView = [hsx|
      <main>
          <div class="container mt-3">
              <h3 class="text-center">Web Speech API Demo</h3>
              <div id="info"></div>
              <div class="float-right">
                <button id="start_button">
                  <img id="start_img" src="images/mic.gif" alt="Start"></button>
              </div>
              <div id="results">
                <span id="final_span" class="final"></span>
                <span id="interim_span" class="interim"></span>
                <p></p>
              </div>
              <div class="row col-12 p-0 m-0">
                <div class="row col-12 col-md-8 col-lg-6 p-0 m-0">
                    <select id="select_language"></select>
                    <select id="select_dialect"></select>
                </div>
                <div class="col-12 col-md-4 col-lg-6 mt-3 mt-md-0 p-0 m-0">
                  <div class="float-right">
                    <button id="copy_button" class="btn btn-primary ">Copy</button>
                  </div>
                </div>
              </div>
          </div>
      </main>
    |]
