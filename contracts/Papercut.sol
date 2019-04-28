pragma solidity ^0.5.0;

contract Factory {

  address public test;

  function newTicketSale(string memory eventName,uint eventDate,uint startTime,uint endTime) public returns(address){
    address payable own = msg.sender;
    ticketSale d = new ticketSale(own,eventName,eventDate,startTime,endTime);
    test = address(d);

    return test;
  }

  /**^Factory contract to generate event contracts. When the newTicketSale function is called,
  the address of the caller is set as the owner of the new TicketApp contract. Only they have the
  ability to add ticket types. WARNING once a ticket type is added, it cannot be removed. CHECK TWICE.
  */

}

contract ticketSale {

  string public eventName;
  uint public eventDate;
  uint public startTime;
  uint public endTime;
  /**event information for the frontend to view. not necessary to contract functionality.
  */
  uint public ticketTypeCount;
  uint public GlobalTicketCount;
  address payable public owner;
  /**Global variables keeping track of the owner of the contract, the total number of tickets avaliable,
  * and the total number of ticket types, going from bottom to top.
  */

  mapping (uint => Ticket) public tickets;			//array of each Ticket struct.
  mapping(address => uint) public totalTicketsOwned;	//keeping track of how many tickets each address has
  mapping(uint =>address) public whoOwnsThis;		//tracking which tickets are associated with each address.
  /** Going from top to bottom:
  *  the tickets mapping is an array of each ticket type
  *  the totalTicketsOwned mapping keeps track of how many tickets each address that bought tickets has
  *  the whoOwnsThis mapping keeps track of all of the tickets and the addresses associated with them if bought
  */

  constructor(address payable own,string memory name,uint date,uint start, uint end)public payable{
    owner = own;
    eventName = name;
    eventDate = date;
    startTime = start;
    endTime = end;
  }
  /** when the contract is initially launched, the owner is set to the initial caller of the function*/

  struct Ticket{ //struct to create each ticket.
    uint ticketType; // Ticket ID
    string ticketName;
    uint maxAmount;	// max amount of that type avaliable
    uint ticketCost;
    uint ticketsSold; //starts at 0, add 1 for each ticket sold
  }
  /** The struct that everything was based off of. Going from top to bottom it contains:
  * ticketType  -- the number of its type where 1 is the first ticket type created, going up from there.
  * ticketName  -- the String name of the ticket itself
  * maxAmount   -- the total avaliable tickets of that type
  * ticketCost  -- the cost of this specific type of ticketCost
  * ticketsSold -- the total number of tickets of this type that have been sold already
  */

  function checkBeforeAddTicket(string memory name,uint max,uint cost) public { //checking if the person calling the contract has the right to add a ticket.
    require(msg.sender == owner,": You don't own me");
    addTicket(name, max, cost);
  }
  /** before adding a ticket to the event/occasion, check if the address attempting to
  *  add a ticket is the owner of the contcostract respective to said event.
  */


  function addTicket( string memory name, uint max, uint cost) private {
    ticketTypeCount ++;
    tickets[ticketTypeCount] = Ticket(ticketTypeCount,name,max,cost,0);
    GlobalTicketCount= GlobalTicketCount += max;

  }
  /** Once an address is verified as the owner, increment the total count of tickets, create a new ticket,
  *  populate its values, and add its maxAmount of tickets to the global count of tickets
  *  remember, cost is in FINNEY 1/1000 of an ether.
  */

  function checkBeforeBuyTicket(uint TicketType, uint quantity, uint totalCost) view private returns (bool) {
    require(TicketType > 0 && TicketType <= ticketTypeCount,": This ticket does not exist,.");
    require(totalTicketsOwned[msg.sender]+quantity <= 5,": You already got 5 tickets");
    require(tickets[TicketType].ticketsSold + quantity <= tickets[TicketType].maxAmount,": There arent that many tickets avaliable, sorry :(");
    require(msg.sender.balance > totalCost, ": You cant afford these");
    return true;
  }
  /**Called by the buy ticket function, this checks the requirements for ticket purchase
  * going from top to bottom, the requirements are:
  * the TicketType must be a number that is associated with a valid ticketType
  * the sum of the tickets being bought, and the tickets already bought from this contract must be >5
  * the quantity being bought + the number already being sold must be smaller or equal to the number avaliable
  * you must have funds for this transaction.
  */

  function PayForThis(uint totalCost)public payable returns(bool){
    owner.transfer(totalCost);
    return true;
  }
  /** within this function, the owner (the ticket seller) is paid the total cost of the tickets.
  */
  function buyTicket(uint TicketType, uint quantity) public payable {	//Where the actual ticket buying occurs.
    uint totalCost = tickets[TicketType].ticketCost*quantity * 1 finney;
    require(checkBeforeBuyTicket(TicketType,quantity,totalCost) == true,": you don't qualify to buy :");	 //checking for if you qualify
    require(PayForThis(totalCost) == true,": for some reason, payment didnt work... huh");
    /** Calculating the total cost, followed by checking the requirements for adding an address
    *  to the list. SEE functions PayForThis and checkBeforeBuyTicket
    */
    int arrayIndex = -1;
    for(uint i=TicketType-1;i>0;i--){
      arrayIndex = (arrayIndex + int(tickets[i].maxAmount));
    }
    arrayIndex += int(tickets[TicketType].ticketsSold);
    /** This first for loop moves the arrayIndex to the correct position for adding an address to the
    *  next avaliable slot within the ticketType's section of the array.
    * it is required because the numbers and addresses for all of the ticket types are stored on 1 array.
    */
    for(uint j = 1; j<=quantity; j++){
      whoOwnsThis[uint(arrayIndex)+j]=msg.sender;
    }
    /** This for loop associates the address of the buyer with the tickets that they bought.
    */
    totalTicketsOwned[msg.sender]+=quantity;
    tickets[TicketType].ticketsSold+=quantity;
    /** Finally, the global count of the total tickets owned is updated followed by the numbers
    * of tickets sold in that type.
    * The remainder of the funding is then refunded to the buyer.
    */
  }

}
