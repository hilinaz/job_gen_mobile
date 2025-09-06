import 'package:flutter/material.dart';

class SearchFilterBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String?) onRoleFilter;
  final Function(bool?) onStatusFilter;
  final Function(String, String) onSort;
  final String? currentRole;
  final bool? currentStatus;
  final String? currentSortBy;
  final String? currentSortOrder;
  final String? initialSearchTerm;

  const SearchFilterBar({
    Key? key,
    required this.onSearch,
    required this.onRoleFilter,
    required this.onStatusFilter,
    required this.onSort,
    this.currentRole,
    this.currentStatus,
    this.currentSortBy,
    this.currentSortOrder,
    this.initialSearchTerm,
  }) : super(key: key);

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedRole;
  bool? _selectedStatus;
  String _sortBy = 'createdAt';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.currentRole;
    _selectedStatus = widget.currentStatus;
    _sortBy = widget.currentSortBy ?? 'createdAt';
    _sortOrder = widget.currentSortOrder ?? 'desc';

    if (widget.initialSearchTerm != null) {
      _searchController.text = widget.initialSearchTerm!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildFilters(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search users...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            widget.onSearch('');
          },
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
      onChanged: (value) {
        // Debounce search
        Future.delayed(const Duration(milliseconds: 300), () {
          if (value == _searchController.text) {
            widget.onSearch(value);
          }
        });
      },
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(child: _buildRoleDropdown()),
        const SizedBox(width: 12),
        Expanded(child: _buildStatusDropdown()),
        const SizedBox(width: 12),
        Expanded(child: _buildSortDropdown()),
        const SizedBox(width: 8),
        _buildSortOrderButton(),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text('Role'),
          value: _selectedRole,
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Roles'),
            ),
            ...['admin', 'user'].map((role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role[0].toUpperCase() + role.substring(1)),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
            });
            widget.onRoleFilter(value);
          },
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<bool?>(
          isExpanded: true,
          hint: const Text('Status'),
          value: _selectedStatus,
          items: const [
            DropdownMenuItem<bool?>(value: null, child: Text('All Status')),
            DropdownMenuItem<bool?>(value: true, child: Text('Active')),
            DropdownMenuItem<bool?>(value: false, child: Text('Inactive')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
            widget.onStatusFilter(value);
          },
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text('Sort By'),
          value: _sortBy,
          items: const [
            DropdownMenuItem<String>(value: 'name', child: Text('Name')),
            DropdownMenuItem<String>(value: 'email', child: Text('Email')),
            DropdownMenuItem<String>(value: 'role', child: Text('Role')),
            DropdownMenuItem<String>(value: 'createdAt', child: Text('Date')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _sortBy = value;
              });
              widget.onSort(_sortBy, _sortOrder);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSortOrderButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc';
        });
        widget.onSort(_sortBy, _sortOrder);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _sortOrder == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
          size: 20,
        ),
      ),
    );
  }
}
