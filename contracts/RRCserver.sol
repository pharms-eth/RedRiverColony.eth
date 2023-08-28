// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// @title Red River Colony
// @author Andre Costa @ Terratecc

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}


/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
    /**
     * @dev The `account` is missing a role.
     */
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);

    /**
     * @dev The caller of a function is not the expected one.
     *
     * NOTE: Don't confuse with {AccessControlUnauthorizedAccount}.
     */
    error AccessControlBadConfirmation();

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     */
    function renounceRole(bytes32 role, address callerConfirmation) external;
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```solidity
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```solidity
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
 * to enforce additional security measures for this role.
 */
abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address account => bool) hasRole;
        bytes32 adminRole;
    }

    mapping(bytes32 role => RoleData) internal _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with an {AccessControlUnauthorizedAccount} error including the required role.
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual returns (bool) {
        return _roles[role].hasRole[account];
    }

    /**
     * @dev Reverts with an {AccessControlUnauthorizedAccount} error if `_msgSender()`
     * is missing `role`. Overriding this function changes the behavior of the {onlyRole} modifier.
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Reverts with an {AccessControlUnauthorizedAccount} error if `account`
     * is missing `role`.
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert AccessControlUnauthorizedAccount(account, role);
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
    function revokeRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     *
     * May emit a {RoleRevoked} event.
     */
    function renounceRole(bytes32 role, address callerConfirmation) public virtual {
        if (callerConfirmation != _msgSender()) {
            revert AccessControlBadConfirmation();
        }

        _revokeRole(role, callerConfirmation);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Attempts to grant `role` to `account` and returns a boolean indicating if `role` was granted.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal virtual returns (bool) {
        if (!hasRole(role, account)) {
            _roles[role].hasRole[account] = true;
            emit RoleGranted(role, account, _msgSender());
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Attempts to revoke `role` to `account` and returns a boolean indicating if `role` was revoked.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual returns (bool) {
        if (hasRole(role, account)) {
            _roles[role].hasRole[account] = false;
            emit RoleRevoked(role, account, _msgSender());
            return true;
        } else {
            return false;
        }
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(msg.sender);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


error RRCServer_ServerNoPermission(
    uint256 serverId,
    address perp,
    string accessPoint
);
error RRCServer_InvalidStringParameter(string param, string value);
error RRCServer_InvalidUint256Parameter(string param, uint256 value);
error RRCServer_Index(uint256 index);
error RRCServer_InvalidAddressParameter(string parameter);
error RRCServer_UserAlreadyExists(uint256 serverId, address user);
error RRCServer_UserNotFound(uint256 serverId, address user);

// error InvalidServerId()
// error InvalidChannelId()
error RRCServer_ChannelAlreadyExists(uint256 channelId);
error RRCServer_ChannelNotFound(uint256 channelId);

//24843
contract RServer is ERC165, IERC721Metadata, Ownable, AccessControl {
    /*
    PENDING

    add more setters for all the channel and server properties

    allow users to reactivate a channel or server after deactivating

    getter function to get a list of all servers and channels a user is part of (some channels might remain after user deletion from server). getter function to get a list of
    all users inside a channel. Should the same be implemented for servers ?

    */

    /*
    EXTRA FEATURES/FUNCTIONALITY TO CONSIDER

    when transferring ownership of a server/channel, also transfer the nft

    possibly include a function to query all servers/channels in one list object instead of going through mapping

    deactivating all channels once a server is deactivated

    add new properties to server and channel along with the setter functions and events

    chanege the name of transfer event to server created event when its the first time

    allow users to accept the transfership of a channel or server instead of simply receiving the nft

    connecting users to other users. follow feature.

    allow the user to join public servers, no need to be added by admin
    */

    using Strings for uint256;

    uint256 internal constant SERVER = 1;
    uint256 internal constant CHANNEL = 2;
    mapping(uint256 => uint256) internal idToType;

    struct Server {
        uint256 id;
        address owner;
        string name;
        address nameResolver;
        bool isActive;
        bool isPublic;
        uint256[] channelIds;
        address[] users;
        //bytes32 role; add admin roles so user can create new channels, add new people, remove people, mute and unmute people
        uint256 generalChannelId;
    }

    
    mapping(uint256 => Server) public servers;
    uint256 public serverCount;

    struct Channel {
        uint256 id;
        uint256 serverId;
        address owner;
        string name;
        bool isActive;
        bool isPublic;
        address[] users;
        //bytes32 role; add admin roles per channel for users to be able to add or revoke access, mute and unmute people
    }
    mapping(uint256 => Channel) public channels;
    uint256 public channelCount;


    struct User {
        address wallet;
        uint256[] serverIds;
        uint256[] channelIds;
    }
    mapping(address => User) public users;
    mapping(address => mapping(uint256 => bool)) public userToChannel;
    mapping(uint256 => mapping(address => bool)) public bannedUsers;
    mapping(uint256 => mapping(address => bool)) public mutedUsers;

    string internal _name;
    string internal _symbol;
    string internal currentBaseURI;

    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    event ServerActiveChanged(uint256 indexed serverId, bool newActive);
    event ServerNameChanged(uint256 indexed serverId, string newName);
    event ServerNameResolverChanged(uint256 indexed serverId, address newName);
    //event ServerIconChanged(uint256 indexed serverId, string newIcon);
    //event ServermessageChanged(uint256 indexed serverId, string newMessage);
    event ServerOwnerChanged(uint256 indexed serverId, address newOwner);
    event ServerAccessChanged(uint256 indexed serverId, bool newAccess);
    event ChannelActiveChanged(uint256 indexed channelId, bool newActive);
    event ChannelNameChanged(uint256 indexed channelId, string newName);
    event ChannelOwnerChanged(uint256 indexed channelId, address newOwner);
    event ChannelAccessChanged(uint256 indexed channelId, bool newAccess);
    event UserDeletedFromServer(uint256 indexed serverId,address indexed userAddress);
    event UserDeletedFromChannel(uint256 indexed channelId,address indexed userAddress);
    event MetadataUpdate(uint256 _tokenId);
    event ChannelDeletedFromServer(uint256 indexed serverId,uint256 indexed channelId);
    event ChannelAddedToServer(uint256 indexed serverId,uint256 indexed channelId);
    event UserAddedToServer(uint256 indexed serverId,address indexed userAddress);
    event UserAddedToChannel(uint256 indexed channelId,address indexed userAddress);
    event UserMutedOnServer(uint256 indexed serverId,address indexed userAddress);
    event UserUnmutedOnServer(uint256 indexed serverId,address indexed userAddress);
    event UserBannedOnServer(uint256 indexed serverId,address indexed userAddress);
    event UserUnbannedOnServer(uint256 indexed serverId,address indexed userAddress);

    constructor() {
        _symbol = "RRCS";
        _name = "Red River Colony";

        _grantRole(0x00, msg.sender);
        _setRoleAdmin(keccak256("ADMIN_ROLE"), 0x00);
    }

    ///
    /// MODIFIERS
    ///


    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165, AccessControl) returns (bool) {
         return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    modifier onlyExistingToken(uint256 tokenId) {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );
        _;
    }

    modifier onlyActive(uint256 tokenId) {
        require(
            idToType[tokenId] == SERVER ? servers[tokenId].isActive : channels[tokenId].isActive,
            "Inactive Token"
        );
        _;
    }

    modifier onlyOwnerOf(uint256 id, string memory _function) {
        address owner_ = _ownerOf(id);
        if (owner_ != msg.sender) {
            revert RRCServer_ServerNoPermission(
                id,
                msg.sender,
                _function
            );
        }
        _;
    }

    modifier onlyServerAdminOf(uint256 id, string memory _function) {
        address serverOwner = _ownerOf(id);
        if (hasRole(keccak256(abi.encodePacked("ADMIN_ROLE_SERVER", id)), msg.sender) || serverOwner != msg.sender) {
            revert RRCServer_ServerNoPermission(
                id,
                msg.sender,
                _function
            );
        }
        _;
    }

    modifier onlyChannelAdminOf(uint256 id, string memory _function) {
        address channelOwner = _ownerOf(id);
        if (hasRole(keccak256(abi.encodePacked("ADMIN_ROLE_CHANNEL", id)), msg.sender) || channelOwner != msg.sender) {
            revert RRCServer_ServerNoPermission(
                id,
                msg.sender,
                _function
            );
        }
        _;
    }

    modifier validateString(string memory _newValue, string memory _parameter) {
        if (bytes(_newValue).length <= 0) {
            revert RRCServer_InvalidStringParameter(_parameter, _newValue);
        }
        _;
    }

    modifier isAddressZero(address _address) {
        if (_address == address(0)) {
            revert RRCServer_InvalidAddressParameter("userAddress");
        }
        _;
    }

    modifier inServer(address userAddress, uint256 id) {
        require(_inServer(userAddress, id), "Not in server");
        _;
    }

    ///
    /// SERVERS
    ///

    /// CREATING & DELETING

    function createServer(string memory serverName, address nameResolver, bool isPublic) external {
        serverCount++;
        uint256 serverId = totalSupply();
        servers[serverId] = Server(
            serverId,
            msg.sender,
            serverName,
            nameResolver,
            true,
            isPublic,
            new uint256[](0),
            new address[](0),
            0
        );

        unchecked {
            _balances[msg.sender] += 1;
        }

        emit Transfer(address(0), msg.sender, serverId);

        uint256 channelId = _createChannel(totalSupply(), "general", true);
        servers[serverId].generalChannelId = channelId;
    }

    //Do we really need to burn the token or should we just deactivate it
    /*
    function deleteServer(uint256 id) external onlyExistingToken(id) onlyOwnerOf(id, "BURN") {
        require(servers[id].isActive, "Server is already deactivated");
        servers[id].isActive = false;

        
        unchecked {
            _balances[msg.sender] -= 1;
        }

        delete _tokenApprovals[id];

        emit Transfer(msg.sender, address(0), id);
        


    }*/

    /// EDITING PROPERTIES

    function setServerActive(uint256 serverId, bool newActive) external onlyExistingToken(serverId) onlyOwnerOf(serverId, "SET SERVER ACTIVE") {
        require(servers[serverId].isActive != newActive, "Current state");
        servers[serverId].isActive = newActive;

        emit ServerActiveChanged(serverId, newActive);
    }

    function setServerAdmin(address admin, uint256 id, bool grant) external onlyOwnerOf(id, "SET SERVER ADMIN") isAddressZero(admin) {
        if (grant) {
            grantRole(keccak256(abi.encodePacked("ADMIN_ROLE_SERVER", id)), admin);
        }
        else {
            revokeRole(keccak256(abi.encodePacked("ADMIN_ROLE_SERVER", id)), admin);
        }
    }

    function setServerName(uint256 serverId, string memory newName) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "SET SERVER NAME") validateString(newName, "name") {
        if (bytes(newName).length > 256) {
            revert RRCServer_InvalidStringParameter("name", newName);
        }

        servers[serverId].name = newName;

        emit ServerNameChanged(serverId, newName);
    }

    function setServerNameResolver(uint256 serverId, address nameResolver) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "SET SERVER NAME RESOLVER") {
        servers[serverId].nameResolver = nameResolver;

        emit ServerNameResolverChanged(serverId, nameResolver);
    }

    function setServerOwner(uint256 serverId, address newOwner) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "SET SERVER ACCESS") isAddressZero(newOwner) {

        servers[serverId].owner = newOwner;

        emit ServerOwnerChanged(serverId, newOwner);
    }

    function setServerAccess(uint256 serverId, bool newAccess) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "SET SERVER ACCESS") {
        require(servers[serverId].isPublic != newAccess, "Current state");
        servers[serverId].isPublic = newAccess;

        emit ServerAccessChanged(serverId, newAccess);
    }

    /*
    function updateServerIcon(uint256 serverId, string memory newIcon) public tokenInRange(serverId) onlyOwnerOf(serverId, "Update Icon") validateString(newIcon, "icon") {
        servers[serverId].icon = newIcon;
        emit ServerIconChanged(serverId, newIcon);
    }

    function updateServerWelcomeMessage(
        uint256 serverId,
        string memory newMessage
    ) public tokenInRange(serverId) onlyOwnerOf(serverId, "Update Welcom Message") validateString(newMessage,"welcome message" ) {
        servers[serverId].message = newMessage;

        emit ServermessageChanged(serverId, newMessage);
    }*/
    

    /// USER HANDLING

    function addUserToServer(uint256 serverId, address userAddress) external onlyExistingToken(serverId) onlyActive(serverId) onlyServerAdminOf(serverId, "ADD USER TO SERVER") isAddressZero(userAddress) {
        require(!bannedUsers[serverId][userAddress], "Banned user!");

        uint256 generalChannelId = servers[serverId].generalChannelId;
        require(!userToChannel[userAddress][generalChannelId], "Already in server");

        userToChannel[userAddress][servers[serverId].generalChannelId] = true;
        users[userAddress].serverIds.push(serverId);
        servers[serverId].users.push(userAddress);
        //channels[generalChannelId].users.push(userAddress); is this really necessary as all users that are in the server have access to this chat
        

        emit UserAddedToServer(serverId, userAddress);
    }

    function deleteUserFromServer(uint256 serverId, address userAddress) external onlyExistingToken(serverId) onlyActive(serverId) onlyServerAdminOf(serverId, "DELETE USER FROM SERVER") isAddressZero(userAddress) inServer(userAddress, serverId) {
        _deleteUserFromServer(serverId, userAddress);
    }

    function _deleteUserFromServer(uint256 serverId, address userAddress) internal {
        User storage user = users[userAddress];
        Server storage server = servers[serverId];

        userToChannel[userAddress][server.generalChannelId] = false;
        
        uint256 serverIndex = getServerIndex(user, serverId);
        // Swap the user to be deleted with the last user in the array
        if (serverIndex < user.serverIds.length - 1) {
            user.serverIds[serverIndex] = user.serverIds[user.serverIds.length - 1];
        }
        // Remove the last user from the array
        user.serverIds.pop();

        uint256 userIndex = getUserIndex(server, userAddress);
        // Swap the user to be deleted with the last user in the array
        if (userIndex < server.users.length - 1) {
            server.users[userIndex] = server.users[server.users.length - 1];
        }
        // Remove the last user from the array
        server.users.pop();

        // Emit an event to indicate that a user was deleted from the server
        emit UserDeletedFromServer(serverId, userAddress);
    }


    
    function banUser(uint256 serverId, address _user) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "BAN USER") inServer(_user, serverId) isAddressZero(_user) {
        require(!bannedUsers[serverId][_user], "User is already banned");
        
        bannedUsers[serverId][_user] = true;
        emit UserBannedOnServer(serverId, _user);

        _deleteUserFromServer(serverId, _user);
    }

    function unbanUser(uint256 serverId, address _user) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "UNBAN USER") inServer(_user, serverId) isAddressZero(_user) {
        require(bannedUsers[serverId][_user], "User is not banned");
        
        bannedUsers[serverId][_user] = false;
        emit UserUnbannedOnServer(serverId, _user);
    }

    function muteUser(uint256 serverId, address _user) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "MUTE USER") inServer(_user, serverId) isAddressZero(_user) {
        require(!mutedUsers[serverId][_user], "User is already muted");
        
        mutedUsers[serverId][_user] = true;
        emit UserMutedOnServer(serverId, _user);
    }

    function unmuteUser(uint256 serverId, address _user) external onlyExistingToken(serverId) onlyActive(serverId) onlyOwnerOf(serverId, "UNMUTE USER") inServer(_user, serverId) isAddressZero(_user) {
        require(mutedUsers[serverId][_user], "User is not muted");
        
        mutedUsers[serverId][_user] = false;
        emit UserUnmutedOnServer(serverId, _user);
    }

    ///
    /// CHANNELS
    ///

    /// CREATING & DELETING

    function createChannel(uint256 serverId, string memory channelName, bool isPublic) external onlyServerAdminOf(serverId, "CREATE CHANNEL") {
        _createChannel(serverId, channelName, isPublic);
    }

    function _createChannel(uint256 serverId, string memory channelName, bool isPublic) internal returns(uint256) {
        channelCount++;
        uint256 channelId = totalSupply();
        channels[channelId] = Channel(
            channelId,
            serverId,
            msg.sender,
            channelName,
            true,
            isPublic,
            new address[](0)
        );
        channels[channelId].users.push(msg.sender);


        unchecked {
            _balances[msg.sender] += 1;
        }

        emit Transfer(address(0), msg.sender, channelId);

        return channelId;
    }

    //Do we really need to burn the token or should we just deactivate it
    /*
    function deleteChannel(uint256 id) external onlyExistingToken(id) onlyOwnerOf(id, "BURN") {
        require(channels[id].isActive, "Channel is already deactivated");
        channels[id].isActive = false;
        
        unchecked {
            _balances[msg.sender] -= 1;
        }

        delete _tokenApprovals[id];

        emit Transfer(msg.sender, address(0), id);
        
    }*/

    /// EDITING PROPERTIES

    function setChannelActive(uint256 channelId, bool newActive) external onlyExistingToken(channelId) onlyOwnerOf(channelId, "SET CHANNEL ACTIVE") {
        require(channels[channelId].isActive != newActive, "Current state");
        channels[channelId].isActive = newActive;

        emit ChannelActiveChanged(channelId, newActive);
    }

    function setChannelAdmin(address admin, uint256 id, bool grant) external onlyOwnerOf(id, "SET CHANNEL ADMIN") isAddressZero(admin) {
        if (grant) {
            grantRole(keccak256(abi.encodePacked("ADMIN_ROLE_CHANNEL", id)), admin);
        }
        else {
            revokeRole(keccak256(abi.encodePacked("ADMIN_ROLE_CHANNEL", id)), admin);
        }
    }

    function setChannelName(uint256 channelId, string memory newName) external onlyExistingToken(channelId) onlyActive(channelId) onlyOwnerOf(channelId, "SET CHANNEL NAME") validateString(newName, "name") {
        if (bytes(newName).length > 256) {
            revert RRCServer_InvalidStringParameter("name", newName);
        }

        channels[channelId].name = newName;

        emit ChannelNameChanged(channelId, newName);
    }

    function setChannelOwner(uint256 channelId, address newOwner) external onlyExistingToken(channelId) onlyActive(channelId) onlyOwnerOf(channelId, "SET CHANNEL OWNER") isAddressZero(newOwner) {

        channels[channelId].owner = newOwner;

        emit ChannelOwnerChanged(channelId, newOwner);
    }

    function setChannelAccess(uint256 channelId, bool newAccess) external onlyExistingToken(channelId) onlyActive(channelId) onlyOwnerOf(channelId, "SET CHANNEL ACCESS") {
        require(channels[channelId].isPublic != newAccess, "Current state");
        channels[channelId].isPublic = newAccess;

        emit ChannelAccessChanged(channelId, newAccess);
    }

    /// USER HANDLING

    function addUserToChannel(uint256 channelId, address userAddress) external onlyExistingToken(channelId) onlyActive(channelId) onlyChannelAdminOf(channelId, "ADD USER TO CHANNEL") isAddressZero(userAddress) inServer(userAddress, channels[channelId].serverId) {
        require(!userToChannel[userAddress][channelId], "Already in channel");

        userToChannel[userAddress][channelId] = true;
        users[userAddress].channelIds.push(channelId);
        channels[channelId].users.push(userAddress); 
        

        emit UserAddedToChannel(channelId, userAddress);
    }

    function deleteUserFromChannel(uint256 channelId, address userAddress) external onlyExistingToken(channelId) onlyActive(channelId) onlyChannelAdminOf(channelId, "DELETE USER FROM CHANNEL") isAddressZero(userAddress) inServer(userAddress, channels[channelId].serverId) {
        require(userToChannel[userAddress][channelId], "Not in channel");
        
        User storage user = users[userAddress];
        Channel storage channel = channels[channelId];

        userToChannel[userAddress][channelId] = false;
        
        uint256 channelIndex = getChannelIndex(user, channelId);
        // Swap the user to be deleted with the last user in the array
        if (channelIndex < user.channelIds.length - 1) {
            user.channelIds[channelIndex] = user.channelIds[user.channelIds.length - 1];
        }
        // Remove the last user from the array
        user.serverIds.pop();

        uint256 userIndex = getUserIndex(channel, userAddress);
        // Swap the user to be deleted with the last user in the array
        if (userIndex < channel.users.length - 1) {
            channel.users[userIndex] = channel.users[channel.users.length - 1];
        }
        // Remove the last user from the array
        channel.users.pop();

        // Emit an event to indicate that a user was deleted from the server
        emit UserDeletedFromChannel(channelId, userAddress);
    }

    ///
    /// VIEWS
    ///

    function getUsersActiveServers(address user) external isAddressZero(user) view returns (uint256[] memory) {
        uint256[] storage userServers = users[user].serverIds;
        uint256 activeCount = 0;

        for (uint256 i = 0; i < userServers.length; i++) {
            if (servers[userServers[i]].isActive) {
                activeCount++;
            }
        }

        uint256[] memory activeServers = new uint256[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < userServers.length; i++) {
            if (servers[userServers[i]].isActive) {
                activeServers[index] = userServers[i];
                index++;
            }
        }

        return activeServers;
    }

    function getUsersActiveChannels(address user) external isAddressZero(user) view returns (uint256[] memory) {
        uint256[] storage userChannels = users[user].channelIds;
        uint256 activeCount = 0;

        for (uint256 i = 0; i < userChannels.length; i++) {
            if (channels[userChannels[i]].isActive) {
                activeCount++;
            }
        }

        uint256[] memory activeChannels = new uint256[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < userChannels.length; i++) {
            if (channels[userChannels[i]].isActive) {
                activeChannels[index] = userChannels[i];
                index++;
            }
        }

        return activeChannels;
    }

    function getServersUsers(uint256 serverId) external onlyExistingToken(serverId) view returns(address[] memory) {
        uint256 generalChannelId = servers[serverId].generalChannelId;
        address[] storage serversUsers = servers[serverId].users;
        uint256 activeCount = 0;

        for (uint256 i = 0; i < serversUsers.length; i++) {
            if (userToChannel[serversUsers[i]][generalChannelId] && !bannedUsers[serverId][serversUsers[i]]) {
                activeCount++;
            }
        }

        address[] memory activeUsers = new address[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < serversUsers.length; i++) {
            if (userToChannel[serversUsers[i]][generalChannelId] && !bannedUsers[serverId][serversUsers[i]]) {
                activeUsers[index] = serversUsers[i];
                index++;
            }
        }

        return activeUsers;
    }

    function getChannelsUsers(uint256 channelId) external onlyExistingToken(channelId) view returns(address[] memory) {
        uint256 serverId = channels[channelId].serverId;
        address[] storage channelsUsers = channels[channelId].users;
        uint256 activeCount = 0;

        for (uint256 i = 0; i < channelsUsers.length; i++) {
            if (userToChannel[channelsUsers[i]][channelId] && !bannedUsers[serverId][channelsUsers[i]]) {
                activeCount++;
            }
        }

        address[] memory activeUsers = new address[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < channelsUsers.length; i++) {
            if (userToChannel[channelsUsers[i]][channelId] && !bannedUsers[serverId][channelsUsers[i]]) {
                activeUsers[index] = channelsUsers[i];
                index++;
            }
        }

        return activeUsers;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view virtual onlyExistingToken(tokenId) returns (string memory) {
        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, idToType[tokenId].toString())) : '';
    }
    

    function _baseURI() internal view virtual returns (string memory) {
        return currentBaseURI;
    }

    function balanceOf(address owner) public view virtual isAddressZero(owner) returns (uint256) {
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address ownerOF = _ownerOf(tokenId);
        require(_exists(tokenId), "ERC721: address zero is not a valid owner");
        return ownerOF;
    }

    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return idToType[tokenId] == SERVER ? servers[tokenId].owner : channels[tokenId].owner;
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    function totalSupply() public view returns (uint256) {
        return serverCount + channelCount /* + lastMessageId*/;
    }

    function tokenByIndex(uint256 _index) external pure returns (uint256) {
        return _index;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
        uint256 count;
        uint256 lastSeen;
        for (uint256 i = 0; i < totalSupply(); i++) {
            count += 1;
            if (_ownerOf(count) == _owner) {
                _index -= 1;
                lastSeen = count;
                if (_index == 0) {
                    return count;
                }
            }
        }

        return lastSeen;
    }

    function getApproved(uint256 tokenId) public view virtual onlyExistingToken(tokenId) returns (address) {
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /// 
    /// OWNER
    ///

    function setAdmin(address admin, uint256 id, bool grant) external onlyOwner {
        if (grant) {
            grantRole(keccak256(abi.encodePacked("ADMIN_ROLE", id)), admin);
        }
        else {
            revokeRole(keccak256(abi.encodePacked("ADMIN_ROLE", id)), admin);
        }
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        currentBaseURI = newBaseURI;
    }

    function withdraw(uint256 amount, address recipient) public onlyOwner {
        (bool success, ) = payable(recipient).call{value: amount}("");
        require(success);
    }

    ///
    /// MISC
    ///

    function _inServer(address userAddress, uint256 id) internal view returns(bool) {
        uint256 generalChannelId = servers[id].generalChannelId;
        return userToChannel[userAddress][generalChannelId] && !bannedUsers[id][userAddress];
    }

    function getUserIndex(
        Server storage server,
        address userAddress
    ) internal view returns (uint256) {
        uint256 len = server.users.length;
        for (uint256 i = 0; i < len; i++) {
            if (server.users[i] == userAddress) {
                return i;
            }
        }
        return len;
    }

    function getUserIndex(
        Channel storage channel,
        address userAddress
    ) internal view returns (uint256) {
        uint256 len = channel.users.length;
        for (uint256 i = 0; i < len; i++) {
            if (channel.users[i] == userAddress) {
                return i;
            }
        }
        return len;
    }

    function getChannelIndex(
        Server storage server,
        uint256 channelId
    ) internal view returns (uint256) {
        uint256 len = server.channelIds.length;
        for (uint256 i = len; i > 0; i--) {
            if (server.channelIds[i - 1] == channelId) {
                return i - 1;
            }
        }
        return len;
    }

    function getChannelIndex(
        User storage user,
        uint256 channelId
    ) internal view returns (uint256) {
         uint256 len = user.channelIds.length;
        for (uint256 i = 0; i < len; i++) {
            if (user.channelIds[i] == channelId) {
                return i;
            }
        }
        return len;
    }

    function getServerIndex(
        User storage user,
        uint256 serverId
    ) internal view returns (uint256) {
        uint256 len = user.serverIds.length;
        for (uint256 i = 0; i < len; i++) {
            if (user.serverIds[i] == serverId) {
                return i;
            }
        }
        return len;
    }

    function contains(
        address[] memory array,
        address element
    ) internal pure returns (bool) {
        uint256 len = array.length;
        for (uint256 i = 0; i < len; i++) {
            if (array[i] == element) {
                return true;
            }
        }
        return false;
    }

    function contains(
        uint256[] memory array,
        uint256 element
    ) internal pure returns (bool) {
        uint256 len = array.length;
        for (uint256 i = 0; i < len; i++) {
            if (array[i] == element) {
                return true;
            }
        }
        return false;
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public virtual {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(_from, _to, _tokenId, data);
    }

	function safeTransferFrom(address _from, address _to, uint256 _tokenId) public virtual {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

	function transferFrom(address from, address to, uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: caller is not token owner or approved");

        _transfer(from, to, tokenId);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory /*data*/) internal virtual {
        _transfer(from, to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];

        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }

        if (idToType[tokenId] == SERVER) {
            servers[tokenId].owner = to; 
        }
        else {
            channels[tokenId].owner = to;
        }
        

        emit Transfer(from, to, tokenId);
    }

	function approve(address to, uint256 tokenId) public virtual {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not token owner or approved for all"
        );

        _approve(to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
}