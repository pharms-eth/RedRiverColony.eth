// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

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
    THIS CONTRACT WILL HOST ALL THE SERVERS, INSIDE THE SERVERS THERE SHOULD BE CHANNELS WHICH INSIDE HAVE MESSAGES. MESSAGES SHOULDNT PERTAIN ON CHAIN 

    CREATE THE MINTING OF EACH OF THESE ELEMENTS INSIDE THIS SMART CONTRACT BUT THEN WE CAN DSIITRIBUTE & DECENTRALIZE IN THE FUTURE.

    MAKE A LIST OF ALL THE POSSIBLE CHARACTERISTICS OF A SERVER, CHANNEL, MESSAGE, USER

    CREATE ACCESS ROLES FOR SMART CONTRACT BUT ALSO FOR USERS TO ACCESS CHANNELS AND SERVERS. ADD ONLY ROLE TO ADMIN FUNCTIONS

    FIND A WAY WE CAN CONNECT USERS TO OTHER USERS

    QUERY LIST OF SERVERS AND CHANNELS FROM USER

    CREATE DIFFERENT IPFS URL DEPENDING ON THE TYPE. STORE TOKEN ID TO TYPE OF NFT

    ALLOW TRANSFER OF OWNERSHIP done

    BLOCK TRANSFER OF NFTS AND APPROVALS

    ADD EXTERNAL FUNCTIONS FOR ADMIN TO GET SERVER AND CHANNEL INFORMATION

    */

    uint256 internal constant SERVER = 1;
    uint256 internal constant CHANNEL = 2;
    mapping(uint256 => uint256) internal idToType;

    struct Server {
        uint256 id;
        address owner;
        string name;
        bool isActive;
        bool isPublic;
        uint256[] channelIds;
        address[] users;
        //bytes32 role; add admin roles so user can create new channels, add new people, remove people, mute and unmute people
    }
    mapping(uint256 => Server) public servers;
    uint256 public lastServerId;

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
    uint256 public lastChannelId;


    struct User {
        address wallet;
        uint256[] serverIds;
        uint256[] channelIds;
    }

    string internal _name;
    string internal _symbol;
    string internal currentBaseURI;


    mapping(uint256 => mapping(address => bool)) bannedUsers;
    mapping(uint256 => mapping(address => bool)) mutedUsers;
    //mapping(uint256 => mapping(address => UserRole)) userRoles;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    event ServerNameChanged(uint256 indexed serverId, string newName);
    event ServerNameResolverChanged(uint256 indexed serverId, address newName);
    event ServerIconChanged(uint256 indexed serverId, string newIcon);
    event ServermessageChanged(uint256 indexed serverId, string newMessage);
    event UserDeletedFromServer(uint256 indexed serverId,address indexed userAddress);
    event MetadataUpdate(uint256 _tokenId);
    event ChannelDeletedFromServer(uint256 indexed serverId,uint256 indexed channelId);
    event ChannelAddedToServer(uint256 indexed serverId,uint256 indexed channelId);
    event UserAddedToServer(uint256 indexed serverId,address indexed userAddress);
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


    // function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    //     return
    //         interfaceId == type(IERC721).interfaceId ||
    //         interfaceId == type(IERC721Metadata).interfaceId ||
    //         interfaceId == type(IERC165).interfaceId;
    // }

    modifier onlyExistingToken(uint256 tokenId) {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
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
        if (hasRole(keccak256(string(abi.encodePacked("ADMIN_ROLE_SERVER", id))), msg.sender) || serverOwner != msg.sender) {
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
        if (hasRole(keccak256(string(abi.encodePacked("ADMIN_ROLE_CHANNEL", id))), msg.sender) || channelOwner != msg.sender) {
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

    ///
    /// SERVERS
    ///

    function createServer(string memory serverName, bool isPublic) external {
        lastServerId++;
        servers[totalSupply()] = Server(
            totalSupply(),
            msg.sender,
            serverName,
            true,
            isPublic,
            new uint256[](0),
            new address[](0)
        );

        unchecked {
            _balances[msg.sender] += 1;
        }

        emit Transfer(address(0), msg.sender, totalSupply());

        _createChannel(totalSupply(), "general", true);
        
    }

    //Do we really need to burn the token or should we just deactivate it
    function deleteServer(uint256 id) external onlyExistingToken(id) onlyOwnerOf(id, "BURN") {
        servers[id].isActive = false;

        unchecked {
            _balances[msg.sender] -= 1;
        }

        delete _tokenApprovals[id];

        emit Transfer(msg.sender, address(0), id);
    }

    function setServerAdmin(address admin, uint256 id, bool grant) external onlyOwnerOf(id) {
        if (grant) {
            grantRole(keccak256(string(abi.encodePacked("ADMIN_ROLE_SERVER", id))), admin);
        }
        else {
            revokeRole(keccak256(string(abi.encodePacked("ADMIN_ROLE_SERVER", id))), admin);
        }
    }

    ///
    /// CHANNELS
    ///

    function createChannel(uint256 serverId, string memory channelName, bool isPublic) external onlyServerAdminOf(serverId) {
        _createChannel(serverId, channelName, isPublic);
    }

    function _createChannel(uint256 serverId, string memory channelName, bool isPublic) internal {
        lastChannelId++;
        channels[totalSupply()] = Server(
            totalSupply(),
            msg.sender,
            channelName,
            true,
            isPublic,
            new address[msg.sender](1)
        );

        unchecked {
            _balances[msg.sender] += 1;
        }

        emit Transfer(address(0), msg.sender, totalSupply());

    }

    //Do we really need to burn the token or should we just deactivate it
    function deleteChannnel(uint256 id) external onlyExistingToken(id) onlyOwnerOf(id, "BURN") {
        channels[id].isActive = false;

        unchecked {
            _balances[msg.sender] -= 1;
        }

        delete _tokenApprovals[id];

        emit Transfer(msg.sender, address(0), id);
    }

    function setChannelAdmin(address admin, uint256 id, bool grant) external onlyOwnerOf(id) {
        if (grant) {
            grantRole(keccak256(string(abi.encodePacked("ADMIN_ROLE_CHANNEL", id))), admin);
        }
        else {
            revokeRole(keccak256(string(abi.encodePacked("ADMIN_ROLE_CHANNEL", id))), admin);
        }
    }

    ///
    /// VIEWS
    ///

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
        require(ownerOF != address(0), "ERC721: address zero is not a valid owner");
        return ownerOF;
    }

    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return servers[tokenId].owner;
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    //possibly include a function to query all in one list object instead of going through mapping
    /*function getServer(uint256 serverId) public view onlyExistingToken(serverId) returns (Server memory) {
        return servers[serverId];
    }*/

    /// 
    /// ADMIN
    ///

    function setAdmin(address admin, uint256 id, bool grant) external onlyOwner {
        if (grant) {
            grantRole(keccak256(string(abi.encodePacked("ADMIN_ROLE", id))), admin);
        }
        else {
            revokeRole(keccak256(string(abi.encodePacked("ADMIN_ROLE", id))), admin);
        }
    }

    /**
     * Sets base URI.
     * @param newBaseURI The base URI
     */
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        currentBaseURI = newBaseURI;
    }

    ///
    /// MISC
    ///

    function withdraw(uint256 amount, address recipient) public onlyOwner {
        (bool success, ) = payable(recipient).call{value: amount}("");
        require(success);
    }

    function banUser(uint256 _serverId, address _user) public tokenInRange(_serverId) onlyOwnerOf(_serverId, "Update Name") {
        bannedUsers[_serverId][_user] = true;
        emit UserBannedOnServer(_serverId, _user);
    }

    function unbanUser(uint256 _serverId, address _user) public tokenInRange(_serverId) onlyOwnerOf(_serverId, "Update Name") {
        bannedUsers[_serverId][_user] = false;
        emit UserUnbannedOnServer(_serverId, _user);
    }

    function isUserBanned(
        uint256 _serverId,
        address _user
    ) public view tokenInRange(_serverId) onlyOwnerOf(_serverId, "Update Name") returns (bool) {
        return bannedUsers[_serverId][_user];
    }

    function muteUser(uint256 _serverId, address _user) public tokenInRange(_serverId) onlyOwnerOf(_serverId, "Update Name") {
        mutedUsers[_serverId][_user] = true;
        emit UserMutedOnServer(_serverId, _user);
    }

    function unmuteUser(uint256 _serverId, address _user) public tokenInRange(_serverId) onlyOwnerOf(_serverId, "Update Name") {
        mutedUsers[_serverId][_user] = false;
        emit UserMutedOnServer(_serverId, _user);
    }

    function isUserMuted(
        uint256 _serverId,
        address _user
    ) public view tokenInRange(_serverId) onlyOwnerOf(_serverId, "Update Name") returns (bool) {
        return mutedUsers[_serverId][_user];
    }

    /*function getUserRole(uint256 _serverId, address _user) public view tokenInRange(_serverId) returns (UserRole) {
        return userRoles[_serverId][_user];
    }*/

    function updateServerName(uint256 serverId, string memory newName) public tokenInRange(serverId) onlyOwnerOf(serverId, "Update Name") validateString(newName, "name") {
        if (bytes(newName).length > 256) {
            revert RRCServer_InvalidStringParameter("name", newName);
        }

        servers[serverId].name = newName;

        emit ServerNameChanged(serverId, newName);
    }

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
    }

    function updateServerNameResolver(uint256 serverId, address nameResolver) public tokenInRange(serverId) onlyOwnerOf(serverId, "Update Name") {
        servers[serverId].nameResolver = nameResolver;

        emit ServerNameResolverChanged(serverId, nameResolver);
    }

    function addUserToServer(uint256 serverId, address userAddress) public tokenInRange(serverId) onlyOwnerOf(serverId, "Add User") isAddressZero(userAddress) {
        if (contains(servers[serverId].users, userAddress)) {
            revert RRCServer_UserAlreadyExists(serverId, userAddress);
        }

        servers[serverId].users.push(userAddress);

        emit UserAddedToServer(serverId, userAddress);
    }

    function deleteUserFromServer(
        uint256 serverId,
        address userAddress
    ) public tokenInRange(serverId) onlyOwnerOf(serverId, "Delete User") isAddressZero(userAddress) {
        Server storage server = servers[serverId];
        uint256 userIndex = getUserIndex(server, userAddress);
        if (userIndex >= server.users.length) {
            revert RRCServer_UserNotFound(serverId, userAddress);
        }

        // Swap the user to be deleted with the last user in the array
        if (userIndex < server.users.length - 1) {
            server.users[userIndex] = server.users[server.users.length - 1];
        }

        // Remove the last user from the array
        server.users.pop();

        // Emit an event to indicate that a user was deleted from the server
        emit UserDeletedFromServer(serverId, userAddress);
    }

    function addChannelToServer(uint256 serverId, uint256 channelId) public tokenInRange(serverId) onlyOwnerOf(serverId, "Add to channels") {
        if (channelId == 0) {
            revert RRCServer_InvalidUint256Parameter("channel id", channelId);
        }
        if (contains(servers[serverId].channels, channelId)) {
            revert RRCServer_ChannelAlreadyExists(channelId);
        }

        servers[serverId].channels.push(channelId);

        emit ChannelAddedToServer(serverId, channelId);
    }

    function deleteChannelFromServer(
        uint256 serverId,
        uint256 channelId
    ) public tokenInRange(serverId) onlyOwnerOf(serverId, "delete channel") {
        Server storage server = servers[serverId];
        uint256 channelIndex = getChannelIndex(server, channelId);
        if (channelIndex == server.channels.length) {
            revert RRCServer_ChannelNotFound(channelId);
        }

        // Swap the channel to be deleted with the last channel in the array
        if (channelIndex < server.channels.length - 1) {
            server.channels[channelIndex] = server.channels[
                server.channels.length - 1
            ];
        }

        // Remove the last channel from the array
        server.channels.pop();

        // Emit an event to indicate that a channel was deleted from the server
        emit ChannelDeletedFromServer(serverId, channelId);
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

    function getChannelIndex(
        Server storage server,
        uint256 channelId
    ) internal view returns (uint256) {
        uint256 len = server.channels.length;
        for (uint256 i = len; i > 0; i--) {
            if (server.channels[i - 1] == channelId) {
                return i - 1;
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

    function totalSupply() public view returns (uint256) {
        return lastServerId + lastChannelId /* + lastMessageId*/;
    }

    function tokenByIndex(uint256 _index) external view tokenInRange(_index) returns (uint256) {
        return _index;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
        uint256 count;
        uint256 lastSeen;
        for (uint256 i = 0; i < serverCount; i++) {
            count += 1;
            if (servers[i].owner == _owner) {
                _index -= 1;
                lastSeen = count;
                if (_index == 0) {
                    return count;
                }
            }
        }

        return lastSeen;
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
        //solhint-disable-next-line max-line-length
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
        servers[tokenId].owner = to;

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

	function getApproved(uint256 tokenId) public view virtual onlyExistingToken(tokenId) returns (address) {
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
}