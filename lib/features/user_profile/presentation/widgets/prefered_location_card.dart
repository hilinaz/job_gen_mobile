import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart' as cp;
import 'package:shared_preferences/shared_preferences.dart';

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

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
  }

  // Load saved preferences from SharedPreferences
  Future<void> _loadSavedPreferences() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      selectedJobType = prefs.getString('jobType') ?? 'Remote';
      selectedState = prefs.getString('state') ?? '';
      selectedCity = prefs.getString('city') ?? '';

      final countryCode = prefs.getString('countryCode');
      final countryName = prefs.getString('countryName');
      if (countryCode != null && countryName != null) {
        selectedCountry = cp.Country(
          countryCode: countryCode,
          name: countryName,
          phoneCode: prefs.getString('phoneCode') ?? '',
          e164Sc: int.tryParse(prefs.getString('e164Sc') ?? '0') ?? 0,
          geographic: prefs.getString('geographic') == 'true',
          level: int.tryParse(prefs.getString('level') ?? '0') ?? 0,
          example: prefs.getString('example') ?? '',
          displayName: prefs.getString('displayName') ?? '',
          displayNameNoCountryCode:
              prefs.getString('displayNameNoCountryCode') ?? '',
          e164Key: prefs.getString('e164Key') ?? '',
        );
      }
    });
  }

  // Save preferences to SharedPreferences
  Future<void> _savePreferences() async {
    final SharedPreferences prefs = await _prefs;

    await prefs.setString('jobType', selectedJobType);
    await prefs.setString('state', selectedState);
    await prefs.setString('city', selectedCity);

    if (selectedCountry != null) {
      await prefs.setString('countryCode', selectedCountry!.countryCode);
      await prefs.setString('countryName', selectedCountry!.name);
      await prefs.setString('phoneCode', selectedCountry!.phoneCode);
      await prefs.setString('e164Sc', selectedCountry!.e164Sc.toString());
      await prefs.setString(
        'geographic',
        selectedCountry!.geographic.toString(),
      );
      await prefs.setString('level', selectedCountry!.level.toString());
      await prefs.setString('example', selectedCountry!.example);
      await prefs.setString('displayName', selectedCountry!.displayName);
      await prefs.setString(
        'displayNameNoCountryCode',
        selectedCountry!.displayNameNoCountryCode,
      );
      await prefs.setString('e164Key', selectedCountry!.e164Key);
    } else {
      await prefs.remove('countryCode');
      await prefs.remove('countryName');
    }
  }

  // Clear all saved preferences
  Future<void> _clearPreferences() async {
    final SharedPreferences prefs = await _prefs;

    await prefs.remove('jobType');
    await prefs.remove('state');
    await prefs.remove('city');
    await prefs.remove('countryCode');
    await prefs.remove('countryName');

    setState(() {
      selectedJobType = 'Remote';
      selectedState = '';
      selectedCity = '';
      selectedCountry = null;
    });
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Preferred Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.teal[800],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 22),
                color: Colors.grey[600],
                onPressed: _clearPreferences,
                tooltip: 'Clear all preferences',
              ),
            ],
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
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
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedJobType = newValue!;
                _savePreferences(); // Save when changed
              });
            },
            underline: const SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
              size: 28,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
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
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
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
                          : Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 28),
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
          _savePreferences(); // Save when changed
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
        final TextEditingController controller = TextEditingController(
          text: selectedState,
        );

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
                      color: Colors.grey[800],
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
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[400]!),
                          ),
                          filled: true,
                          fillColor: Colors.white,
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
                            _savePreferences(); // Save when changed
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(
          text: selectedCity,
        );

        return Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter City',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your city',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        selectedCity = controller.text.trim();
                        _savePreferences(); // Save when changed
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Save City'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
