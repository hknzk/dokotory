//==========================================================onPageLoadの定義

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

function setPreviewImage(files) {
  document.querySelectorAll('.previewImage').forEach(i => {
    i.parentNode.removeChild(i);
  });

  for(var i = 0; i < files.length; i++) {
    var file = files[i];
    var blobUrl = window.URL.createObjectURL(file);
    var img = document.createElement('img');
    img.src = blobUrl;
    img.classList.add('previewImage');
    // document.body.appendChild(img);
    dragArea.appendChild(img);
  }
}
//=============================================================

onPageLoad(['articles#new', 'articles#edit'],()=>{
  var fileField = document.getElementById('article_images');
  var dragArea = document.getElementById('dragArea');
  var dt = new DataTransfer(); //iOS,IEでは不可能.
  var clearImagesButton = document.getElementById('clearImagesButton');

  fileField.addEventListener('change', (e)=>{
    setPreviewImage(e.target.files);
  });

  dragArea.addEventListener('dragover',(e)=>{
    e.preventDefault();
    e.target.style.backgroundColor = 'rgb(154, 154, 154)';
  });

  dragArea.addEventListener('dragleave',(e)=>{
    e.target.style.backgroundColor = 'rgb(231, 231, 231)';
  });

  dragArea.addEventListener('drop',(e)=>{
    if (dt.files.length >= 3) {
      clearImagesButton.style.display = 'inline-block';
      return;
    }
    e.preventDefault();
    e.target.style.backgroundColor = 'rgb(231, 231, 231)';

    clearImagesButton.style.display = 'inline-block';

    dt.items.add(e.dataTransfer.files[0]);
    fileField.files = dt.files;

    setPreviewImage(fileField.files);

    if (dt.files.length >= 3) {
      // dragArea.firstElementChild.textContent = 'これ以上画像を送付できません。';
    }
  });

  clearImagesButton.addEventListener('click', ()=>{
    clearImagesButton.style.display = 'none';
    dt.clearData();
    fileField.files = dt.files;
    setPreviewImage(fileField.files);
    dragArea.firstElementChild.textContent = '送付したい画像を3枚までドラッグ&ドロップ';
  });
});

onPageLoad('articles#show',()=>{
  var fileField = document.getElementById('comment_image');
  var dragArea = document.getElementById('dragArea');
  var dt = new DataTransfer()
  var articleMainImg = document.querySelector('.main_img');
  var articleSubImgs = document.querySelectorAll('.sub_img');
  var clearCommentImagesButton = document.getElementById('clearCommentImagesButton')

  var imageTab = document.querySelector('.image_tab');
  var framesWrapper = document.querySelector('.frames_wrapper');
  var mapTab = document.querySelector('.map_tab');
  var mapInfoWrapper = document.querySelector('.map_info_wrapper');

  articleSubImgs.forEach((img)=>{
    img.addEventListener('click',()=>{
      console.log('aaa');
      articleMainImg.firstElementChild.src = img.getAttribute('data-image-path');
      articleMainImg.href = img.getAttribute('data-image-path');
    });
  });

  console.log('aaa');
  fileField.addEventListener('change',(e)=>{
    setPreviewImage(e.target.files)
    if (e.target.files.length > 0) {
      clearCommentImagesButton.style.display = 'inline-block';
    }
  });

  dragArea.addEventListener('dragover',(e)=>{
    e.preventDefault();
    // e.target.style.backgroundColor = 'red';
  });

  dragArea.addEventListener('dragleave',(e)=>{
    e.preventDefault();
    // e.target.style.backgroundColor = 'pink';
  });

  dragArea.addEventListener('drop',(e)=>{
    e.preventDefault();
    // e.target.style.backgroundColor = 'pink';
    fileField.files = e.dataTransfer.files
    setPreviewImage(fileField.files);

    console.log(fileField.files);

    if (fileField.files.length > 0) {
      clearCommentImagesButton.style.display = 'inline-block';
    }
  });

  clearCommentImagesButton.addEventListener('click', ()=>{
    dt.clearData();
    fileField.files = dt.files
    setPreviewImage(fileField.files);
    clearCommentImagesButton.style.display = 'none';
  });

  imageTab.addEventListener('click',()=>{
    imageTab.classList.add('selected');
    framesWrapper.style.display ='block';
    mapTab.classList.remove('selected');
    mapInfoWrapper.style.display ='none';
  });

  mapTab.addEventListener('click',()=>{
    imageTab.classList.remove('selected');
    framesWrapper.style.display ='none';
    mapTab.classList.add('selected');
    mapInfoWrapper.style.display ='block';
  });
});

onPageLoad('articles#visitor',()=>{

  var articleMainImg = document.querySelector('.main_img');
  var articleSubImgs = document.querySelectorAll('.sub_img');

  var imageTab = document.querySelector('.image_tab');
  var framesWrapper = document.querySelector('.frames_wrapper');
  var mapTab = document.querySelector('.map_tab');
  var mapInfoWrapper = document.querySelector('.map_info_wrapper');

  articleSubImgs.forEach((img)=>{
    img.addEventListener('click',()=>{
      console.log('aaa');
      articleMainImg.firstElementChild.src = img.getAttribute('data-image-path');
      articleMainImg.href = img.getAttribute('data-image-path');
    });
  });

  imageTab.addEventListener('click',()=>{
    imageTab.classList.add('selected');
    framesWrapper.style.display ='block';
    mapTab.classList.remove('selected');
    mapInfoWrapper.style.display ='none';
  });

  mapTab.addEventListener('click',()=>{
    imageTab.classList.remove('selected');
    framesWrapper.style.display ='none';
    mapTab.classList.add('selected');
    mapInfoWrapper.style.display ='block';
  });
});
