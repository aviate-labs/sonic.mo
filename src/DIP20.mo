/// A standard token interface is a basic building block for many applications on
/// the Internet Computer, such as wallets and decentralized exchanges, in this 
/// specification we propose a standard token interface for fungible tokens on 
/// the IC. This standard provides basic functionality to transfer tokens, allow 
/// tokens to be approved so they can be spent by a third-party, it also provides
/// interfaces to query history transactions.
//
/// More Info: https://github.com/Psychedelic/DIP20
module DIP20 {
    /// Basic token information.
    public type Metadata = {
        /// Fee for update calls.
        fee         : Nat;
        /// Token decimals.
        decimals    : Nat8;
        /// Token owner.
        owner       : Principal;
        /// A base64 encoded logo or logo url.
        logo        : Text;
        /// Token name.
        name        : Text;
        /// Token total supply.
        totalSupply : Nat;
        /// Token symbol.
        symbol      : Text;
    };

    /// Receipt for update calls, contains the transaction index or an error message.
    /// When the Transaction status is #failed, an error should be returned instead of a transaction id.
    public type TxReceipt = {
        #Ok  : Nat;
        #Err : TxError;
    };

    public type TokenInfo = {
        holderNumber : Nat64;
        deployTime   : Nat64;
        metadata     : Metadata;
        historySize  : Nat64;
        cycles       : Nat64;
        feeTo        : Principal;
    };

    public type TxError = {
        #InsufficientAllowance;
        #InsufficientBalance;
        #ErrorOperationStyle;
        #Unauthorized;
        #LedgerTrap;
        #ErrorTo;
        #Other : Text;
        #BlockUsed;
        #AmountTooSmall;
    };

    public type Interface = actor {
        /// Returns the amount which `spender` is still allowed to withdraw from `owner`.
        allowance        :  query (owner : Principal, spender : Principal) -> async (allowance : Nat);
        /// Allows `spender` to withdraw tokens from your account, up to the `value` 
        /// amount. If it is called again it overwrites the current allowance with value. 
        /// There is no upper limit for value.
        approve          : shared (spender : Principal, value : Nat) -> async TxReceipt;
        /// Returns the balance of user `who`.
        balanceOf        :  query (who : Principal) -> async (balance : Nat);
        /// Returns the decimals of the token.
        decimals         :  query () -> async (decimals : Nat8);
        getHolders       :  query (start : Nat64, limit : Nat64) -> async [(Principal, Nat)];
        /// Returns the metadata of the token.
        getMetadata      :  query () -> async (metadata : Metadata);
        /// Returns the logo of the token.
        logo             :  query () -> async (logo : Text);
        /// Returns the name of the token.
        name             :  query () -> async (name : Text);
        /// Returns the owner of the token.
        owner            :  query () -> async (owner : Principal);
        /// Returns the symbol of the token.
        symbol           :  query () -> async (symbol : Text);
        /// Returns the total supply of the token.
        totalSupply      :  query () -> async (totalSupply : Nat);
        /// Transfers `value` amount of tokens to user `to`, returns a `TxReceipt`
        /// which contains the transaction index or an error message.
        transfer         : shared (to : Principal, value : Nat) -> async TxReceipt;
        /// Transfers `value` amount of tokens from user `from` to user `to`, this
        /// method allows canister smart contracts to transfer tokens on your behalf,
        /// it returns a `TxReceipt` which contains the transaction index or an error message.
        transferFrom     : shared (from : Principal, to : Principal, value : Nat) -> async TxReceipt;
    };

    public type OptionalInterface = actor {
        /// Burn `value` number of new tokens from user `from`, this will decrease
        /// the token total supply, only `owner` or the user `from` can perform this operation.
        burn             : shared (amount : Nat) -> async TxReceipt;
        /// Mint `value` number of new tokens to user `to`, this will increase the 
        /// token total supply, only `owner` is allowed to mint new tokens.
        mint             : shared (to : Principal, value : Nat) -> async TxReceipt;
        /// Set fee to `newFee` for update calls (`approve`, `transfer`, `transferFrom`), no return value needed.
        setFee           : shared (newFee : Nat) -> async ();
        /// Set fee receiver to `newFeeTo`, no return value needed.
        setFeeTo         : shared (feeTo : Principal) -> async ();
        /// Change the logo of the token, no return value needed. The `logo` can either
        /// be a base64 encoded text of the logo picture or an URL pointing to the logo picture.
        setLogo          : shared (logo : Text) -> async ();
        /// Change the name of the token, no return value needed.
        setName          : shared (name : Text) -> async ();
        /// Set the owner of the token to newOwner, no return value needed.
        setOwner         : shared (owner : Principal) -> async ();
    };
};
