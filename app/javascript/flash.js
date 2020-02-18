// flashメッセージを3秒後に削除する
function flash_hide(){
  var obj = document.getElementById("msg_notice");  
  if(obj){
    obj.parentNode.removeChild(obj); 
  }
  
  obj = document.getElementById("msg_alert");  
  if(obj){
    obj.parentNode.removeChild(obj); 
  }
}

window.onload= function(){
  setTimeout(flash_hide,3000);
}