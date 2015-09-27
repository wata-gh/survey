class @Survey
  @init_single_graph: (idx, opt) ->
    $("#container#{idx}").highcharts
      chart:
        plotBackgroundColor: null
        plotBorderWidth: null
        plotShadow: false
        type: 'pie'
      title: text: opt.title
      subtitle: text: ''
      xAxis:
        categories: opt.categories
        crosshair: true
      yAxis:
        min: 0
        allowDecimals: false
        title: text: '回答数'
      tooltip:
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y} 件</b></td></tr>'
        footerFormat: '</table>'
        shared: true
        useHTML: true
      plotOptions: pie:
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: true
          format: '<b>{point.name}</b>: {point.percentage:.1f} %'
          style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
      series: [ {
        name: '回答数'
        data: opt.data
      } ]

  @init_multile_graph: (idx, opt) ->
    $("#container#{idx}").highcharts
      chart: type: 'column'
      colors: [ '#21ba45' ]
      title: text: opt.title
      subtitle: text: ''
      xAxis:
        categories: opt.categories
        crosshair: true
      yAxis:
        min: 0
        allowDecimals: false
        title: text: '回答数'
      tooltip:
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' + '<td style="padding:0"><b>{point.y:.1f} 件</b></td></tr>'
        footerFormat: '</table>'
        shared: true
        useHTML: true
      plotOptions: column:
        pointPadding: 0.2
        borderWidth: 0
      series: [ {
        name: '回答数'
        data: opt.data
      } ]

  @init_date_graph: (idx, opt) ->
    $("#container#{idx}").highcharts
      chart: type: 'bar'
      colors: [
        '#b5cc18'
        '#21ba45'
      ]
      title: text: opt.title
      xAxis: categories: opt.categories
      yAxis:
        min: 0
        allowDecimals: false
        title: text: '集計結果'
      legend: reversed: true
      plotOptions: series: stacking: 'normal'
      series: opt.series
