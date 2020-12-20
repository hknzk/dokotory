

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

//=========================================================

onPageLoad('home#top', ()=>{

   var ctx = document.getElementById('top_chart');
   var graphValues = gon.graph_values;
   var topChart;
   var daysLabel = [];
   var maximumValue = Math.max.apply(null, graphValues);
   var scale;

   for (var i = 0; i < 10; i++) {
     var now = new Date();
     var day = new Date(now.getFullYear(), now.getMonth(), now.getDate() - i);
     daysLabel.unshift(`${day.getMonth() + 1}月${day.getDate()}日`);
   }

   if (maximumValue <= 10) {
     scale = {step: 1, max: 10};
   } else if (maximumValue <= 50) {
     scale = {step: 5, max: 50};
   } else {
     scale = {step: 10, max: 100};
   }

  topChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: daysLabel,
      datasets: [
        {
          label: '保護されたことりの数',
          data: graphValues,
          borderColor: "rgb(102, 204, 55)",
          backgroundColor: "rgba(0,0,0,0)"
        }
      ],
    },
    options: {
      title: {
        display: true,
        text: `${daysLabel[0]} ~ ${daysLabel.slice(-1)[0]}`
      },
      scales: {
        yAxes: [{
          ticks: {
            suggestedMax: scale.max,
            suggestedMin: 0,
            stepSize: scale.step,
            callback: function(value, index, values){
              return  value +  '羽'
            }
          }
        }]
      },
    }
  });
});

onPageLoad('mypage#messages', ()=>{
  tabs = document.querySelectorAll('.tab');
  tables = document.querySelectorAll('table');

  tabs.forEach((tab, index) =>{
    tab.addEventListener('click', ()=>{
      tabs.forEach(t =>{
        t.classList.add('inactive');
      });
      tables.forEach(t =>{
        t.classList.add('inactive');
      });
      tab.classList.remove('inactive');
      tables[index].classList.remove('inactive');
    });
  });
});
