var PaperCut = artifacts.require('./Papercut.sol');


contract('PaperCut', function(accounts) {
  it("should assert true", function(done) {
    var paper_cut = PaperCut.deployed();
    assert.isTrue(true);
    done();
  });
});

/*
contract('PaperCut', function(accounts) {
  it("should return newTicketSale", function() {
    var papercut = PaperCut.deployed();
    var output = papercut.then(function(instance){return instance.newTicketSale("Test Event 1",04172019,1800,2300,{from: ownerAccount});})
    assert.isTrue(true);
  });
});
*/
