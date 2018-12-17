pragma solidity ^0.4.25;

contract WorkbenchBase {
    event WorkbenchAddProduct(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    constructor(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function AddProduct() internal {
        emit WorkbenchAddProduct(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        emit WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract Product is WorkbenchBase('Product', 'Product')
{
    enum StateType { Active, productPlaced, PendingInspection, Inspected, Appraised, NotionalAcceptance, BuyerAccepted, SellerAccepted, Accepted, Rejectd }
    address public Manufacturer;
    string public UPC_Code;
    string public ProductName;
    string public Description;
    string public Size;
    string public Quantity;
    string public LotNumber;
    StateType public State;

    address public Vendor;
    uaddress public Distributor;
    address public Retailer;

    constructor(string upccode,string productname,string description,string size,string quanity,string lotNumber) public
    {
        Manufacturer = msg.sender;
        UPC_Code = upccode;
        ProductName=productname;
        Description = description;
        Size =size;
        Quantity=quanity;
        string LotNumber=lotNumber
        State = StateType.Active;
        AddProduct();
    }

    function Reject() public
    {
        if (Manufacturer != msg.sender)
        {
            revert();
        }

        State = StateType.Rejectd;
        ContractUpdated('Reject');
    }

    function Modify(string description, uint256 price) public
    {
        if (State != StateType.Active)
        {
            revert();
        }
        if (Manufacturer != msg.sender)
        {
            revert();
        }

        Size =size;
        Quantity=quanity;
        ContractUpdated('Modify');
    }

    

    

    function Reject() public
    {
        
        if (Manufacturer != msg.sender)
        {
            revert();
        }

        Vendor = 0x0;
        State = StateType.Active;
        ContractUpdated('Reject');
    }

    function Accept() public
    {
        if (State != StateType.Reject)
        {
            revert();
        }
        if (Manufacturer != msg.sender)
        {
            revert();
        }

        State = StateType.Accept;
        ContractUpdated('Accepted');
    }
    
}
