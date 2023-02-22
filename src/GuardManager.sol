// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity >=0.7.0 <0.9.0;

import "./deps/IERC165.sol";
import "./deps/Enum.sol";
import "./deps/SelfAuthorized.sol";
import "./OwnerManager.sol";

interface Guard is IERC165 {
    function checkTransaction(
        address to,
        uint256 value,
        bytes memory data,
        Enum.Operation operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address payable refundReceiver,
        bytes memory signatures,
        address msgSender
    ) external;

    function checkAfterExecution(bytes32 txHash, bool success) external;
}

abstract contract BaseGuard is Guard {
    function supportsInterface(
        bytes4 interfaceId
    ) external view virtual override returns (bool) {
        return
            interfaceId == type(Guard).interfaceId || // 0xe6d7a83a
            interfaceId == type(IERC165).interfaceId; // 0x01ffc9a7
    }
}

/**
 * @title Guard Manager - A contract managing transaction guards which perform pre and post-checks on Safe transactions.
 * @author Richard Meissner - @rmeissner
 */
contract GuardManager is SelfAuthorized {
    event ChangedGuard(address guard);
    address private guard;

    /**
     * @dev Set a guard that checks transactions before execution
     *      This can only be done via a Safe transaction.
     * @notice Set Transaction Guard `guard` for the Safe.
     * @param guard_ The address of the guard to be used or the 0 address to disable the guard
     */
    function setGuard(address guard_) external authorized {
        if (guard != address(0)) {
            require(
                Guard(guard_).supportsInterface(type(Guard).interfaceId),
                "GS300"
            );
        }
        guard = guard_;
        emit ChangedGuard(guard);
    }

    function getGuard() public view returns (address) {
        return guard;
    }
}
