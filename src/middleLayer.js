var name;
var time;
var timeEnd;
var date;

//function to grab user buying tickets
function grabValues() {
    var artist = document.getElementById("artistName").value;
    alert(artist);
    var quantity = document.getElementById("numTickets").value;
    alert(quantity);
}

//function to grab created event values
 function eventValues() {
    name = document.getElementById("artistName").value;
     date = document.getElementById("eventDate").value;
     time = document.getElementById("eventTime").value;
     timeEnd = document.getElementById("eventTimeEnd").value;
    alert(name +" "+ date+" "+time+""+timeEnd);
    console.log(name);
    console.log(date);
    console.log(time);
    console.log(timeEnd);
    passing(name,date,time,timeEnd);

}

//checking if we can access the value of the info should pass to blockchain contract
/*var arrInfo[];
var who;
var tim;
var dat;
 function passing(a,b,c,d) {
     who = a;
    alert(who);
     tim = c;
    alert(tim);
     dat = c;
    alert(dat);
};*/
