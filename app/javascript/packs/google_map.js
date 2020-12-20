
window.initMap = function() {
  //空メソッド
};

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

//======================================================googleMapApi共通の定義

var target;
var prefectureSelector;//new ediit
var substitute;//new edit
var lat; // new edit
var lng; // new edit
var latLng;
var isMapEnabled;// new edit
var mapCenterSelector;// new edit
var googleMapWrapper;
var mapSwicth;

var map;
var marker;
var geocorder;

var tokyo = {lat: 35.681167, lng: 139.767052};
var prefectures = [
  'マップをクリックして選択してください',
  '北海道',
  '青森県',
  '岩手県',
  '宮城県',
  '秋田県',
  '山形県',
  '福島県',
  '茨城県',
  '栃木県',
  '群馬県',
  '埼玉県',
  '千葉県',
  '東京都',
  '神奈川県',
  '新潟県',
  '富山県',
  '石川県',
  '福井県',
  '山梨県',
  '長野県',
  '岐阜県',
  '静岡県',
  '愛知県',
  '三重県',
  '滋賀県',
  '京都府',
  '大阪府',
  '兵庫県',
  '奈良県',
  '和歌山県',
  '鳥取県',
  '島根県',
  '岡山県',
  '広島県',
  '山口県',
  '徳島県',
  '香川県',
  '愛媛県',
  '高知県',
  '福岡県',
  '佐賀県',
  '長崎県',
  '熊本県',
  '大分県',
  '宮崎県',
  '鹿児島県',
  '沖縄県',
];

var locations = {
  hokkaido: {lat: 43.06417, lng: 141.34694 },
  aomori: {lat: 40.814461, lng: 140.739216 },
  iwate: {lat: 39.705242, lng: 141.153436 },
  miyagi: {lat: 38.26889, lng: 140.87194 },
  akita: {lat: 39.713219, lng: 140.100595 },
  yamagata: {lat: 38.259241, lng: 140.336422 },
  fukushima: {lat: 37.759840, lng: 140.474085 },
  ibaragi: {lat: 36.364709, lng: 140.472702 },
  tochigi: {lat: 36.556332, lng: 139.880485 },
  gunma: {lat: 36.390499, lng: 139.064527 },
  saitama: {lat: 35.860151, lng: 139.644560 },
  chiba: {lat: 35.605114, lng: 140.096384 },
  tokyo: {lat: 35.68944, lng: 139.69167 },
  kanagawa: {lat: 35.44778, lng: 139.6425 },
  niigata: {lat: 37.90222, lng: 139.02361 },
  toyama: {lat: 36.69528, lng: 137.21139 },
  ishikawa: {lat: 36.59444, lng: 136.62556 },
  fukui: {lat: 36.06528, lng: 136.22194 },
  yamanashi: {lat: 35.66389, lng: 138.56833},
  nagano: {lat: 36.65139, lng: 138.18111 },
  gifu: {lat: 35.39111, lng: 136.72222 },
  shizuoka: {lat: 34.97694, lng: 138.38306 },
  aichi: {lat: 35.18028, lng: 136.90667 },
  mie: {lat: 34.73028, lng: 136.50861 },
  shiga: {lat: 35.00444, lng: 135.86833 },
  kyoto: {lat: 35.02139, lng: 135.75556 },
  osaka: {lat: 34.68639, lng: 135.52 },
  hyogo: {lat: 34.69139, lng: 135.18306 },
  nara: {lat: 34.68528, lng: 135.83278 },
  wakayama: {lat: 34.22611, lng: 135.1675 },
  tottori: {lat: 35.50361, lng: 134.23833 },
  shimane: {lat: 35.47222, lng: 133.05056 },
  okayama: {lat: 34.66167, lng: 133.935 },
  hiroshima: {lat: 34.39639, lng: 132.45944 },
  yamaguchi: {lat: 34.18583, lng: 131.47139 },
  tokushima: {lat: 34.06583, lng: 134.55944 },
  kagawa: {lat: 34.34028, lng: 134.04333 },
  ehime: {lat: 33.84167, lng: 132.76611 },
  kochi: {lat: 33.55972, lng: 133.53111 },
  fukuoka: {lat: 33.60639, lng: 130.41806 },
  saga: {lat: 33.24944, lng: 130.29889 },
  nagasaki: {lat: 32.74472, lng: 129.87361 },
  kumamoto: {lat: 32.78972, lng: 130.74167 },
  oita: {lat: 33.23806, lng: 131.6125 },
  miyazaki: {lat: 31.91111, lng: 131.42389 },
  kagoshima: {lat: 31.56028, lng: 130.55806 },
  okinawa: {lat: 26.2125, lng: 127.68111 },
};

function getPrefectureName(geoCodeResults) {
  if (geoCodeResults.length <= 1) {
    return null;
  }
  var result = geoCodeResults[0].address_components.filter(component => {
    return component.types.indexOf("administrative_area_level_1") > -1;
  });
  return result[0].long_name;
}

function getCountryName(geoCodeResults) {
  var result = geoCodeResults[0].address_components.filter(component => {
    return component.types.indexOf("country") > -1;
  });
  return result[0].long_name;
}

function initializeForm() {
  if (isMapEnabled.checked) {
    googleMapWrapper.style.display = 'block';
    substitute.textContent = prefectures[prefectureSelector.options.selectedIndex];
    substitute.style.display = 'inline-block'
    mapCenterSelector.disabled = false;
    prefectureSelector.style.display = 'none';
    lat.readOnly = false;
    lng.readOnly = false;
    map.setOptions({
      zoom: 12,
      disableDefaultUI: false,
      scrollwheel: true,
      gestureHandling: 'auto',
      clickableIcons: true,
    });
  } else {
    googleMapWrapper.style.display = 'none';
    substitute.style.display = 'none'
    mapCenterSelector.disabled = true;
    mapCenterSelector.options.selectedIndex = 0;
    prefectureSelector.style.display = 'block';
    lat.readOnly = true;
    lng.readOnly = true;
    lat.value = null;
    lng.value = null;
    map.setOptions({
      center: tokyo,
      zoom: 12,
      disableDefaultUI: true,
      scrollwheel: false,
      gestureHandling: 'none',
      clickableIcons: false,
    });
    if (marker) {
      marker.setMap(null);
    }
  }
}

function initializeMap() {
  var latlng
  if (lat.value && lng.value) {
    latlng = {
      lat: parseFloat(lat.value),
      lng: parseFloat(lng.value),
    }
    map = new google.maps.Map(target, {
      center: latlng,
      zoom: 12
    });
    marker = new google.maps.Marker({
      position: latlng,
      map: map,
      title: '発見場所',
      animation: google.maps.Animation.DROP,
    });
  } else {
    latlng = tokyo;
    map = new google.maps.Map(target, {
      center: latlng,
      zoom: 12
    });
  }
}

function panMapToSelectedLocation(selectElement) {
    var name = selectElement.options[selectElement.options.selectedIndex].value;
    map.setOptions({
      center: locations[name]
    });
}

function setMarker(latLng) {
  marker = new google.maps.Marker({
    position: latLng,
    map: map,
    title: '発見場所',
    animation: google.maps.Animation.DROP,
  });
}

function setMarkerAndFillForm(latLng) { //ピンどめの処理 //new edit
  if (!isMapEnabled.checked) {
    return;
  }
  if (marker) {
    marker.setMap(null);
    lat.value = null;
    lng.value = null;
  }
  geocoder.geocode(
    {location: latLng},
    (results, status) => {
      if (status !== 'OK') {
        alert('Faild: ' + status + ':国内の陸地を選択してください');
        return;
      }
      console.log(results);
      if (getCountryName(results) != '日本') {
        alert('国内の陸地を選択してください');
        return;
      }
      if (getPrefectureName(results) == null) {
        alert('国内の陸地を選択してください');
        return;
      }
      if (results[0]) {
        setMarker(latLng);
        lat.value = latLng.lat().toFixed(6);
        lng.value = latLng.lng().toFixed(6);
      }
      prefectureSelector.options.selectedIndex = prefectures.indexOf(getPrefectureName(results));
      substitute.textContent = getPrefectureName(results);

      console.log(getCountryName(results));
      console.log(getPrefectureName(results));
    })
}

function rel() {
  if (window.name != "any") {
    document.querySelector('.contents .main').textContent ='しばらくおまちください。';
    // document.body.textContent = 'しばらくおまちください。'
    location.reload();
    window.name = "any";
  } else {
    window.name = "";
  }
}

///=======================================================article#new=======

onPageLoad('articles#new', ()=>{
  console.log('rendering_map...');

  target = document.getElementById('mapTarget');// new edit show board
  prefectureSelector = document.getElementById('article_prefecture');//new ediit
  substitute = document.getElementById('substitute_prefecture');//new edit
  lat = document.getElementById('map_lat'); // new edit
  lng = document.getElementById('map_lng'); // new edit
  isMapEnabled = document.getElementById('map_is_enabled');// new edit
  mapCenterSelector = document.getElementById('map_location');// new edit
  geocoder = new google.maps.Geocoder() //new edit
  googleMapWrapper = document.querySelector('.google_map_wrapper');
  mapSwicth = document.querySelector('.map_switch input');

  initializeMap();
  initializeForm();

  isMapEnabled.addEventListener('change',()=>{
    initializeForm();
    prefectureSelector.options.selectedIndex = 0;
    substitute.textContent = 'マップをクリックして選択してください';
  });

  mapSwicth.addEventListener('change', e =>{
    isMapEnabled.click();
  });

  mapCenterSelector.addEventListener('change', e =>{panMapToSelectedLocation(e.target)});
  map.addListener('click', e =>{setMarkerAndFillForm(e.latLng)});
  prefectureSelector.addEventListener('click',()=>{
    isMapEnabled.checked = false;
    initializeForm();
  });
});

///=======================================================article#edit=======

onPageLoad('articles#edit', ()=>{
  target = document.getElementById('mapTarget');// new edit show board
  prefectureSelector = document.getElementById('article_prefecture');//new ediit
  substitute = document.getElementById('substitute_prefecture');//new edit
  lat = document.getElementById('map_lat'); // new edit
  lng = document.getElementById('map_lng'); // new edit
  isMapEnabled = document.getElementById('map_is_enabled');// new edit
  mapCenterSelector = document.getElementById('map_location');// new edit
  geocoder = new google.maps.Geocoder() //new edit
  googleMapWrapper = document.querySelector('.google_map_wrapper');
  mapSwicth = document.querySelector('.map_switch');

  initializeMap();
  initializeForm();

  isMapEnabled.addEventListener('change',()=>{
    initializeForm();
    prefectureSelector.options.selectedIndex = 0;
    substitute.textContent = 'マップをクリックして選択してください';
  });
  mapSwicth.addEventListener('change', e =>{
    isMapEnabled.click();
  });
  mapCenterSelector.addEventListener('change', e =>{panMapToSelectedLocation(e.target)});
  map.addListener('click', e =>{setMarkerAndFillForm(e.latLng)});
  prefectureSelector.addEventListener('click',()=>{
    isMapEnabled.checked = false;
    initializeForm();
  });

});

onPageLoad(['articles#show','articles#visitor'], ()=>{
  lat = document.getElementById('map_lat');
  lng = document.getElementById('map_lng');
  target = document.getElementById('mapTarget');
  latLng = {lat: parseFloat(lat.value), lng: parseFloat(lng.value) }

  initializeMap();
  setMarker(latLng);
  console.log(parseFloat(lat.value));
  console.log(parseFloat(lng.value));
});

onPageLoad('articles#map', ()=>{

  rel();
  if (window.name == "any") {
    return;
  }


  var search = document.getElementById('searchButton');
  var loadArticle = document.getElementById('loadArticle');
  // var prefectureButtons = document.querySelectorAll('.prefecture_button');
  var markers = [];
  var mask = document.querySelector('.mask');
  var close = document.querySelector('.a_close');
  var articleDetailsNode = document.getElementById('articleDetails');

  mapCenterSelector = document.getElementById('map_location');
  target = document.getElementById('mapTarget');

  if (locations[gon.centerPrefecture] != null) {
    map = new google.maps.Map(target, {
      center: locations[gon.centerPrefecture],
      zoom: 9
    });
  }

  console.log(gon.centerPrefecture);

  if (gon.maps == null) {
    console.log('null');
  } else {
    gon.maps.forEach((m)=>{
      latlng = {
        lat: parseFloat(m.lat),
        lng: parseFloat(m.lng),
      };
      marker = new google.maps.Marker({
        map: map,
        position: latlng,
        title: '発見場所',
        animation: google.maps.Animation.DROP,
      });

      marker.addListener('click', ()=>{
        var url = '/articles/load_detail?article_id=' + m.article_id.toString();
        loadArticle.href = url
        loadArticle.click();
      });
    });
  }

  mapCenterSelector.addEventListener('change',()=>{
    search.click();
  });

  close.addEventListener('click', ()=>{
    articleDetailsNode.classList.remove('active');
    mask.classList.remove('active');
  });

  mask.addEventListener('click', ()=>{
    close.click();
  });

});
