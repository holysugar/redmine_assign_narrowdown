class NarrowdownListener < Redmine::Hook::ViewListener
  def view_issues_edit_notes_bottom(*args)
js=<<'JS'
(function(){
  var id_enabled = "issue_assigned_to_id";
  var id_disabled = "issue_assigned_to_id_disabled";
  var e = document.getElementById(id_enabled);
  if(e){
    var useridlist={};
    $$("a[href*=users]").each(function(a){
      if(/users\/([\d]+)/.test(a.href)){
        useridlist[RegExp.$1]=true;
      }
    });
    var is = document.createElement("input");
    is.setAttribute("type","checkbox");
    e.parentNode.insertBefore(is,e.nextSibling);
    var label = document.createElement("span");
    label.appendChild(document.createTextNode("関係者のみ"));
    label.for = "only-concerned";
    label.setAttribute("style","font-size:80%;cursor:pointer");
    is.id = label.for;
    e.parentNode.insertBefore(label,is.nextSibling);
    
    var copiedselect = e.cloneNode(true);
    copiedselect.id = id_disabled;
    copiedselect.style.display = "none";
    var options = copiedselect.options;
    
    for (var i = 0, l = options.length; i < l; i++) {
      var o = options[i];
      console.log(o);
      if (!useridlist[o.value]){
        jQuery(o).attr("data-toremove", '1');
      }
    }
    e.parentNode.insertBefore(copiedselect, e.nextSibling);
    jQuery('option[data-toremove=1]').remove();

    $(is).on("change", function(ev) {
      if (ev.target.checked) {
        copiedselect.id = id_enabled;
        copiedselect.style.display = "";
        e.id = id_disabled;
        e.style.display = "none";
        console.log('enabled');
      } else {
        copiedselect.id = id_disabled;
        copiedselect.style.display = "none";
        e.id = id_enabled;
        e.style.display = "";
        console.log('disabled');
      }
    });
  }
})();
JS

  "<script>//<![CDATA[\n#{js}\n//]]></script>"
  end
end