let speechInitialized = false;

function initSpeech() {
    const url = $('#url').text();
    if (url == "") {
        return false;
    }
    const sender = encodeURIComponent($('#sender').text());
    if (sender == "") {
        return false;
    }

    console.log(`URL: ${url}`);
    console.log(`Sender: ${sender}`);

    const transcriber = makeTranscriber();
    transcriber.start(
        () => {}, 
        sendWords, 
        () => {}, 
        (error, message) => { console.log(message); }
    );

    function sendWords(grouping, final, words) {
        const finalParam = final ? "True" : "False";
        const wordsParam = encodeURIComponent(words);

        const xmlhttp = new XMLHttpRequest();
        xmlhttp.open("POST", url + `?sender=${sender}&isFinal=${finalParam}&words=${wordsParam}`);
        xmlhttp.send();
    }

    return true;
}

$(document).on('ready turbolinks:load', function () {
    if (!speechInitialized) {
        speechInitialized = initSpeech();
    }
});
