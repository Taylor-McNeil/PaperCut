var papercutInstance;
var DeployedAddress;
var theEvent;
var test;

App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',


  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    var status = $("#status");
    // This is the secret sauce to get Metamask to work with a dapp - It asks for authorization to access your accounts information
    if (window.ethereum) {
      window.web3 = new Web3(ethereum);
      try {
        ethereum.enable();
      } catch (err) {
        $('#status').html('User denied account access', err)
      }
    } else if (window.web3) {
      window.web3 = new Web3(web3.currentProvider)

    } else {
      $('#status').html('No Metamask (or other Web3 Provider) installed')
    }
    App.web3Provider = web3.currentProvider;

    return App.initContract();
  },

  initContract: function() {
  $.getJSON("Factory.json", function(papercut) {
    // Instantiate a new truffle contract from the artifact
    App.contracts.Factory = TruffleContract(papercut);
    // Connect provider to interact with contract
    App.contracts.Factory.setProvider(App.web3Provider);

    // App.listenForEvents();

    return App.render();
  });
 },

 render: function() {
    //var papercutInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    App.contracts.Factory.deployed().then(function(instance){
      papercutInstance = instance;
     test = web3.eth.contract(instance);

    }).then(function(eventName) {
      console.log(papercutInstance);
      console.log(test);
    })
  },


 redirect: async function() {
   document.location.href="tickets.html"
},



 addEvent: async function() {

    var eventNameId= document.getElementById("eventName").value;
    var dateId= parseInt(document.getElementById("eventDate").value);
    var eventTimeId= parseInt(document.getElementById("eventTime").value);
    var eventTimeEnd= parseInt(document.getElementById("eventTimeEnd").value);



papercutInstance.newTicketSale(eventNameId,dateId,eventTimeId,eventTimeEnd,{from:App.acc});
DeployedAddress = await papercutInstance.test();


//console.log(ticketSale);
console.log(DeployedAddress);
  },




createTickets: function(){

  var _ticketName= document.getElementById("ticketName").value;
  var _numofTickets = parseInt(document.getElementById("numOfTickets").value);
  var cost = parseInt(document.getElementById("ticketCost").value);


//theEvent.checkBeforeAddTicket(_ticketName,_numofTickets, cost,{from: App.acc});}
/*theEvent.then(function(instance){return instance.checkBeforeAddTicket(_ticketName,_numofTickets, cost,{from: App.acc});})*/

//console.log(DeployedAddress.cost);
 },

purchaseTickets: function(){
var artistChoice = document.getElementById("artistName").value;
var __numofTickets = document.getElementById('numTickets').value;
var __tickettype = document.getElementById('typeOfTickets').value;

console.log(artistChoice);
console.log(__numofTickets);
console.log(__tickettype);
console.log(typeof(__tickettype));
console.log(typeof(__numofTickets));
}

};
$(function() {
  $(window).load(function() {
    App.init();
  });
});
