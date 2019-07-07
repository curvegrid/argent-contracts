pragma solidity ^0.5.4;
import "../wallet/BaseWallet.sol";

/**
 * @title Interface for a contract that can loan tokens to a wallet.
 * @author Julien Niset - <julien@argent.xyz>
 */
interface Loan {

    /**
     * @dev Opens a collateralized loan.
     * @param _wallet The target wallet.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral token provided.
     * @param _debtToken The token borrowed.
     * @param _debtAmount The amount of tokens borrowed.
     * @param _oracles (optional) The address of one or more oracles contracts that may be used by the provider to query information on-chain.
     * @return (optional) An ID for the loan when the provider enables users to create multiple distinct loans.
     */
    function openLoan(
        BaseWallet _wallet, 
        address _collateral, 
        uint256 _collateralAmount, 
        address _debtToken, 
        uint256 _debtAmount, 
        address[] calldata _oracles
    ) 
        external 
        returns (bytes32 _loanId);

    /**
     * @dev Closes a collateralized loan by repaying all debts (plus interest) and redeeming all collateral (plus interest).
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _oracles (optional) The address of one or more oracles contracts that may be used by the provider to query information on-chain.
     */
    function closeLoan(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address[] calldata _oracles
    ) 
        external;

    /**
     * @dev Adds collateral to a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to add.
     * @param _oracles (optional) The address of one or more oracles contracts that may be used by the provider to query information on-chain.
     */
    function addCollateral(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _collateral, 
        uint256 _collateralAmount, 
        address[] calldata _oracles
    ) 
        external;

    /**
     * @dev Removes collateral from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to remove.
     * @param _oracles (optional) The address of one or more oracles contracts that may be used by the provider to query information on-chain.
     */
    function removeCollateral(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _collateral, 
        uint256 _collateralAmount, 
        address[] calldata _oracles
    ) 
        external;

    /**
     * @dev Increases the debt by borrowing more token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _debtToken The token borrowed.
     * @param _debtAmount The amount of token to borrow.
     * @param _oracles (optional) The address of one or more oracles contracts that may be used by the provider to query information on-chain.
     */
    function addDebt(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _debtToken, 
        uint256 _debtAmount, 
        address[] calldata _oracles
    ) 
        external;

    /**
     * @dev Decreases the debt by repaying some token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _debtToken The token to repay.
     * @param _debtAmount The amount of token to repay.
     * @param _oracles (optional) The address of one or more oracles contracts that may be used by the provider to query information on-chain.
     */
    function removeDebt(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _debtToken, 
        uint256 _debtAmount, 
        address[] calldata _oracles
    ) 
        external;

    /**
     * @dev Gets information about a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _oracles (optional) The address of one or more oracles contracts that may be used by the provider to query information on-chain.
     * @return a status [0: no loan, 1: loan is safe, 2: loan is unsafe and can be liquidated, 3: unable to provide info]
     * and a value (in ETH) representing the value that could still be borrowed when status = 1; or the value of the collateral 
     * that should be added to avoid liquidation when status = 2.     
     */
    function getLoan(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address[] calldata _oracles
    ) 
        external 
        view 
        returns (uint8 _status, uint256 _ethValue);
}