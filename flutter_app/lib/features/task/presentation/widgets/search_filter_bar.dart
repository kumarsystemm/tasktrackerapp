import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Function(String?) onStatusFilterChanged;
  final String? currentStatus;

  const SearchFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari task...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => onSearchChanged(''),
              ),
            ),
            onChanged: onSearchChanged,
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Semua',
                  isSelected: currentStatus == null,
                  onTap: () => onStatusFilterChanged(null),
                ),
                SizedBox(width: 8),
                _FilterChip(
                  label: 'Pending',
                  isSelected: currentStatus == 'pending',
                  onTap: () => onStatusFilterChanged('pending'),
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                _FilterChip(
                  label: 'Done',
                  isSelected: currentStatus == 'done',
                  onTap: () => onStatusFilterChanged('done'),
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
