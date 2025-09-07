import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/job_management/job_management_bloc.dart';
import '../bloc/job_management/job_management_event.dart';
import '../bloc/job_management/job_management_state.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/custom_notification.dart';
import '../../data/models/job_model.dart';
import '../../domain/entities/job.dart';

class JobFormScreen extends StatefulWidget {
  final Job? job; // If provided, we're editing an existing job

  const JobFormScreen({Key? key, this.job}) : super(key: key);

  @override
  State<JobFormScreen> createState() => _JobFormScreenState();
}

class _JobFormScreenState extends State<JobFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryRangeController = TextEditingController();
  final _skillsController = TextEditingController();
  
  String _jobType = 'full-time';
  int _experienceYears = 0;
  DateTime _postedDate = DateTime.now();
  DateTime? _deadline;
  bool _isActive = true;
  
  final List<String> _jobTypes = ['full-time', 'part-time', 'contract', 'internship', 'remote'];

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      // Populate form with existing job data
      _titleController.text = widget.job!.title;
      _companyController.text = widget.job!.company;
      _descriptionController.text = widget.job!.description;
      _locationController.text = widget.job!.location;
      _salaryRangeController.text = widget.job!.salaryRange;
      _skillsController.text = widget.job!.skills.join(', ');
      _jobType = widget.job!.type;
      _experienceYears = widget.job!.experienceYears;
      _postedDate = widget.job!.postedDate;
      _deadline = widget.job!.deadline;
      _isActive = widget.job!.isActive;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryRangeController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final List<String> skills = _skillsController.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toList();

      final JobModel jobModel = JobModel(
        id: widget.job?.id ?? '', // Empty ID for new jobs, will be assigned by backend
        title: _titleController.text,
        company: _companyController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        type: _jobType,
        skills: skills,
        experienceYears: _experienceYears,
        salaryRange: _salaryRangeController.text,
        postedDate: _postedDate,
        deadline: _deadline,
        isActive: _isActive,
        source: widget.job?.source ?? 'manual',
      );

      if (widget.job == null) {
        // Create new job
        context.read<JobManagementBloc>().add(CreateJobEvent(job: jobModel));
      } else {
        // Update existing job
        context.read<JobManagementBloc>().add(UpdateJobEvent(
              jobId: widget.job!.id,
              job: jobModel,
            ));
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isDeadline) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? (_deadline ?? DateTime.now()) : _postedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDeadline) {
          _deadline = picked;
        } else {
          _postedDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: widget.job == null ? 'Create Job' : 'Edit Job',
      ),
      body: BlocConsumer<JobManagementBloc, JobManagementState>(
        listener: (context, state) {
          if (state is JobCreationSuccess) {
            CustomNotification.show(
              context: context,
              message: 'Job created successfully',
              type: NotificationType.success,
            );
            Navigator.pop(context, true); // Return to previous screen with success flag
          } else if (state is JobUpdateSuccess) {
            CustomNotification.show(
              context: context,
              message: 'Job updated successfully',
              type: NotificationType.success,
            );
            Navigator.pop(context, true); // Return to previous screen with success flag
          } else if (state is JobManagementError) {
            CustomNotification.show(
              context: context,
              message: state.message,
              type: NotificationType.error,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Job Title *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a job title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(
                          labelText: 'Company *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a company name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _jobType,
                        decoration: const InputDecoration(
                          labelText: 'Job Type *',
                          border: OutlineInputBorder(),
                        ),
                        items: _jobTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _jobType = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a job description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _skillsController,
                        decoration: const InputDecoration(
                          labelText: 'Skills (comma separated) *',
                          border: OutlineInputBorder(),
                          hintText: 'e.g. Flutter, Dart, Firebase',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter at least one skill';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _salaryRangeController,
                              decoration: const InputDecoration(
                                labelText: 'Salary Range',
                                border: OutlineInputBorder(),
                                hintText: 'e.g. \$50,000 - \$70,000',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _experienceYears,
                              decoration: const InputDecoration(
                                labelText: 'Experience (Years)',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(11, (index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text(index == 0 ? 'Entry Level' : '$index years'),
                                );
                              }),
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _experienceYears = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Posted Date',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(_postedDate),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Deadline (Optional)',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: _deadline != null
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              _deadline = null;
                                            });
                                          },
                                        )
                                      : null,
                                ),
                                child: Text(
                                  _deadline != null
                                      ? DateFormat('yyyy-MM-dd').format(_deadline!)
                                      : 'No Deadline',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Active'),
                        value: _isActive,
                        onChanged: (bool value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state is JobManagementLoading ? null : _submitForm,
                          child: Text(
                            widget.job == null ? 'Create Job' : 'Update Job',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (state is JobManagementLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
