function makeTranscriber(onError) {        
    const upgradeMessage = 'Web Speech API is not supported by this browser. It is only supported by <a href="//www.google.com/chrome">Chrome</a> version 25 or later on desktop and Android mobile.';
    const noSpeechMessage = 'No speech was detected. You may need to adjust your <a href="//support.google.com/chrome/answer/2693767" target="_blank">microphone settings</a>.';
    const noMicMessage = 'No microphone was found. Ensure that a microphone is installed and that <a href="//support.google.com/chrome/answer/2693767" target="_blank">microphone settings</a> are configured correctly.';
    const deniedMessage = 'Permission to use microphone was denied.';
    const blockedMessage = 'Permission to use microphone is blocked. To change, go to chrome://settings/content/microphone';

    let recognition = null;
    let requestedStop = false;

    function start(onStarted, onWords, onStopped, onFailed) {
        if (recognition != null) {
            return;
        }

        recognition = new webkitSpeechRecognition();
        requestedStop = false;

        recognition.continuous = true;
        recognition.interimResults = true;
        recognition.lang = 6; // English

        const startTime = now();

        function handleStarted() {
            onStarted();
        }
    
        function handleWords(event) {
            var finalWords = '';
            var immediateWords = '';
            for (let i = event.resultIndex; i < event.results.length; ++i) {
                const result = event.results[i];
                if (result.isFinal) {
                    finalWords += result[0].transcript;
                } else {
                    immediateWords += result[0].transcript;
                }
            }
            if (finalWords.length > 0) {
                onWords(event.resultIndex, true, finalWords);
            } else if(immediateWords.length > 0) {
                onWords(event.resultIndex, false, immediateWords);
            }
        }

        function handleEnd() {
            recognition = null;
    
            if (requestedStop) {
                onStopped();
            } else {
                console.log("restarting");
                start(() => {}, onWords, onStopped, onFailed);
            }
        }
    
        function handleError(event) {
            recognition = null;
    
            if (event.error == 'no-speech') {
                onFailed('no-speech', noSpeechMessage);
            } else if (event.error == 'audio-capture') {
                onFailed('no-mic', noMicMessage);
            } else if (event.error == 'not-allowed') {
                if (event.timeStamp - startTime < 100) {
                    onFailed('blocked', blockedMessage);
                } else {
                    onFailed('denied', deniedMessage);
                }
            }
        }
    
        function now() {
            return new Date().getTime();
        }

        recognition.onstart = handleStarted;
        recognition.onresult = handleWords;
        recognition.onerror = handleError;
        recognition.onend = handleEnd;

        recognition.start();
    }

    function stop() {
        requestedStop = true;

        if (recognition != null) {
            recognition.stop();
            recognition = null;
        }
    }

    return {
        start: start,
        stop: stop
    };
}
