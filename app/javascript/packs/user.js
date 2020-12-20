function onPageLoad(controller_and_actions, callback) {
  document.addEventListener('turbolinks:load', ()=>{
    const conditions = regularize(controller_and_actions);
    if (!conditions) {
      console.error('[onPageLoad] Unexpected arguments!');
      return;
    }
    conditions.forEach(a_controller_and_action =>{
      const [controller, action] = a_controller_and_action.split('#');
      if (isOnPage(controller, action)) {
        callback();
      }
    });
  });
}

function regularize(controller_and_actions) {
  if (typeof controller_and_actions == 'string') {
    return[controller_and_actions];
  } else if (
    Object.prototype.toString.call(controller_and_actions).includes('Array')
    //controller_and_actions.isArray()
  ) {
    return controller_and_actions;
  } else {
    return null;
  }
}

function isOnPage(controller, action) {
  var selector = `body[data-controller='${controller}']`;
  if (!!action) {
    selector += `[data-action='${action}']`
  };
  return document.querySelectorAll(selector).length > 0;
}

onPageLoad('users#edit_profile', ()=>{
  console.log('sss');
  var fileField = document.getElementById('user_avatar');
  var previewAvatar = document.getElementById('preview_avatar');

  fileField.addEventListener('change', e =>{
    console.log(e.target.files[0]);
    var blobUrl = window.URL.createObjectURL(e.target.files[0]);
    var img = document.createElement('img');
    img.src = blobUrl;
    // document.body.appendChild(img);
    previewAvatar.classList.remove('inactive');
    previewAvatar.appendChild(img);
  });
});
