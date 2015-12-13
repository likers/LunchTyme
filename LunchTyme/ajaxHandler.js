$( document ).ajaxSend(function( event, request, settings )  {

      callNativeApp (settings.data);

});



function callNativeApp (data) {
try {
    webkit.messageHandlers.callbackHandler.postMessage(data);
}

catch(err) {
    console.log('The native context does not exist yet');
}
}