function showId(id) {
  document.getElementById(id).style.display = "";
}

function hideId(id) {
  document.getElementById(id).style.display = "none";
}

function show_folder_contents(path, auth_token){
  new Ajax.Updater('folder-files', path, {asynchronous:true, evalScripts:true, parameters:'authenticity_token=' + encodeURIComponent(auth_token)})
}