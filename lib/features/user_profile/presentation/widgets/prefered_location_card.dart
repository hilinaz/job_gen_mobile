import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart' as cp;

class PreferedLocationCard extends StatefulWidget {
  const PreferedLocationCard({super.key});

  @override
  State<PreferedLocationCard> createState() => _PreferedLocationCardState();
}

class _PreferedLocationCardState extends State<PreferedLocationCard> {
  cp.Country? selectedCountry;
  String selectedState = '';
  String selectedCity = '';
  String selectedJobType = 'Remote';

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(26.0),
      width: deviceWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferred Location',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.teal[800],
            ),
          ),
          const SizedBox(height: 16),

          // Job Type Selection
          _buildJobTypeDropdown(),
          const SizedBox(height: 24),

          Text(
            'Country, State & City',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),

          // Country Selection
          _buildLocationField(
            label: 'Country',
            value: selectedCountry?.name ?? '',
            onTap: () {
              _showCountryPicker(context);
            },
          ),
          const SizedBox(height: 16),

          // State Selection
          _buildLocationField(
            label: 'State',
            value: selectedState,
            onTap: () {
              if (selectedCountry == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a country first'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              _showStatePicker(context);
            },
          ),
          const SizedBox(height: 16),

          // City Selection
          _buildLocationField(
            label: 'City',
            value: selectedCity,
            onTap: () {
              if (selectedState.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a state first'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              _showCityPicker(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job type',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal[200]!, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedJobType,
            items: ['Remote', 'Onsite', 'Hybrid'].map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.teal[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedJobType = newValue!;
              });
            },
            underline: const SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.teal[700],
              size: 28,
            ),
            dropdownColor: Colors.teal[50],
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            style: TextStyle(color: Colors.teal[800], fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.teal[800],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal[200]!, width: 1.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? 'Select $label' : value,
                    style: TextStyle(
                      fontSize: 16,
                      color: value.isEmpty
                          ? Colors.grey[500]
                          : Colors.teal[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.teal[700], size: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) {
    cp.showCountryPicker(
      context: context,
      onSelect: (cp.Country country) {
        setState(() {
          selectedCountry = country;
          selectedState = '';
          selectedCity = '';
        });
      },
    );
  }

  void _showStatePicker(BuildContext context) {
    if (selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a country first')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Since the country_picker package doesn't provide states,
        // we'll show a text input for the user to enter their state
        final TextEditingController controller = TextEditingController();

        return Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select State',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Enter your state/province',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          setState(() {
                            selectedState = controller.text.trim();
                            selectedCity = '';
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Save State'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCityPicker(BuildContext context) {
    if (selectedCountry == null || selectedState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select country and state first')),
      );
      return;
    }

    // This is a simplified version - you'll need to replace this with actual city data
    // from your API or data source
    final List<String> cities = [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select City',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cities[index]),
                        onTap: () {
                          setState(() {
                            selectedCity = cities[index];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
