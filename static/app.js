function initSpeech() {
    const url = $('#url').text();

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
        xmlhttp.open("POST", url + `?grouping=${grouping}&isFinal=${finalParam}&words=${wordsParam}`);
        xmlhttp.send();
    }
}

$(document).ready(function () {
    initSpeech();
});

$(document).on('ready turbolinks:load', function () {
});
