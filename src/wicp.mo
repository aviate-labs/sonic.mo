import DIP20 "dip20";

module {
    public let CANISTER_ID : Text = "utozz-siaaa-aaaam-qaaxq-cai";

    type TxReceipt = {
        #Ok  : Nat; 
        #Err : TxError;
    };
    
    type TxError = {
        #InsufficientAllowance;
        #InsufficientBalance;
        #ErrorOperationStyle;
        #Unauthorized;
        #LedgerTrap;
        #ErrorTo;
        #Other; // NOTE: this is different from DIP20! 
        #BlockUsed;
        #AmountTooSmall;
    };

    /// More Info: https://github.com/Psychedelic/wicp/blob/main/wicp/wicp.did
    public type Interface = actor {
        /// Returns the amount which `spender` is still allowed to withdraw from `owner`.
        allowance : query (owner : Principal, spender : Principal) -> async Nat;
        approve : shared (spender : Principal, value : Nat) -> async TxReceipt;
        /// Returns the balance of user `who`.
        balanceOf : query (who : Principal) -> async Nat;
        /// Returns the decimals of the token.
        decimals : query () -> async Nat8;
        getAllowanceSize : query () -> async Nat64;
        getBlockUsed : query () -> async [Nat64];
        getHolders : query (Nat64, Nat64) -> async [(Principal, Nat)];
        /// Returns the metadata of the token.
        getMetadata : query () -> async DIP20.Metadata;
        getTokenInfo : query () -> async DIP20.TokenInfo;
        getUserApprovals : query (Principal) -> async [(Principal, Nat)];
        /// Returns the history size.
        historySize : query () -> async Nat64;
        isBlockUsed : query (Nat64) -> async Bool;
        /// Returns the logo of Wrapped ICP (WICP).
        logo : query () -> async Text;
        mint : shared (subAccount : ?[Nat8], blockHeight : Nat64) -> async TxReceipt;
        mintFor : shared (?[Nat8], Nat64, Principal) -> async TxReceipt;
        /// Returns the name of Wrapped ICP (WICP).
        name : query () -> async Text;
        owner : query () -> async Principal;
        setFee : shared (Nat) -> async ();
        setFeeTo : shared (Principal) -> async ();
        setGenesis : shared () -> async TxReceipt;
        setLogo : shared (Text) -> async ();
        setName : shared (Text) -> async ();
        setOwner : shared (Principal) -> async ();
        /// Returns the symbol of the token.
        symbol : query () -> async (Text);
        /// Returns the total supply of the token.
        totalSupply : query () -> async (Nat);
        transfer : shared (to : Principal, value : Nat) -> async TxReceipt;
        transferFrom : shared (from : Principal, to : Principal, value : Nat) -> async TxReceipt;
        /// value : An integer that represents the amount of WICP you’d like to withdraw to ICP.
        /// to    : A string that should be the Account ID that you wish the ICP to be transferred to.
        withdraw : shared (value : Nat64, to : Text) -> async TxReceipt;
    };
};
