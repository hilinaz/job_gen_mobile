import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/job_management/job_management_bloc.dart';
import '../bloc/job_management/job_management_event.dart';
import '../bloc/job_management/job_management_state.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/custom_notification.dart';
import '../widgets/delete_confirmation_modal.dart';
import '../../domain/entities/job.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Job Details'),
      body: BlocListener<JobManagementBloc, JobManagementState>(
        listener: (context, state) {
          if (state is JobUpdateSuccess) {
            CustomNotification.show(
              context: context,
              message: 'Job status updated successfully',
              type: NotificationType.success,
            );
          } else if (state is JobDeletionSuccess) {
            CustomNotification.show(
              context: context,
              message: 'Job deleted successfully',
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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildJobDetails(),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
            BlocBuilder<JobManagementBloc, JobManagementState>(
              builder: (context, state) {
                if (state is JobManagementLoading) {
                  return Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Chip(
                  label: Text(job.isActive ? 'Active' : 'Inactive'),
                  backgroundColor: job.isActive ? Colors.green[100] : Colors.red[100],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              job.company,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(job.location),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.work, size: 16),
                const SizedBox(width: 4),
                Text(job.type),
              ],
            ),
            if (job.salaryRange.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16),
                  const SizedBox(width: 4),
                  Text(job.salaryRange),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text('Experience: ${job.experienceYears} ${job.experienceYears == 1 ? 'year' : 'years'}'),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('Source: ${job.source}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetails() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(job.description),
            const Divider(height: 32),
            const Text(
              'Skills Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Colors.blue[50],
                );
              }).toList(),
            ),
            const Divider(height: 32),
            const Text(
              'Dates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text('Posted: ${_formatDate(job.postedDate)}'),
              ],
            ),
            if (job.deadline != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.event),
                  const SizedBox(width: 8),
                  Text('Deadline: ${_formatDate(job.deadline!)}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/admin/jobs/edit',
                arguments: job,
              ).then((result) {
                if (result == true) {
                  // Refresh job details if edited successfully
                  Navigator.pop(context, true);
                }
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(job.isActive ? Icons.visibility_off : Icons.visibility),
            label: Text(job.isActive ? 'Deactivate' : 'Activate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: job.isActive ? Colors.orange : Colors.green,
            ),
            onPressed: () {
              _toggleJobStatus(context);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              _confirmDelete(context);
            },
          ),
        ),
      ],
    );
  }

  void _toggleJobStatus(BuildContext context) {
    // Create a copy of the job with toggled active status
    final updatedJob = (job as dynamic).copyWith(
      isActive: !job.isActive,
    );

    context.read<JobManagementBloc>().add(UpdateJobEvent(
          jobId: job.id,
          job: updatedJob,
        ));
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationModal(
        title: 'Delete Job',
        content: 'Are you sure you want to delete this job? This action cannot be undone.',
        onConfirm: () {
          Navigator.pop(context); // Close dialog
          context.read<JobManagementBloc>().add(DeleteJobEvent(jobId: job.id));
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
