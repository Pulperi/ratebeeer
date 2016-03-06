var BEERS = {};

BEERS.show = function(){
    var table = $("#beertable");

    $.each(BEERS.list, function (index, beer) {
        table.append('<tr>'
            + '<td>'+beer['name']+'</td>'
            + '<td>'+beer['style']['name']+'</td>'
            + '<td>'+beer['brewery']['name']+'</td>'
            + '</tr>');
    });
};
BEERS.reverse = function(){
    BEERS.list.reverse();
};

$(document).ready(function () {
    $("#reverse").click(function (e) {
        BEERS.reverse();
        BEERS.show();
        e.preventDefault();
    });

    $.getJSON('beers.json', function (beers) {
        BEERS.list = beers;
        BEERS.show();
    });
});