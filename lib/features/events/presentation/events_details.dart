import 'package:app/core/style/app_colors.dart';
import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/features/events/presentation/cubit/event_details/event_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatelessWidget {
  final String id;
  const EventDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventDetailsCubit()..getEventDetails(id),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomTopBar.withCart(
          context: context,
          showBackButton: true,
          showLogo: true,
          logoHeight: 200,
          logoWidth: 0,
          centerTitle: false,
          showNotificationButton: true,
        ),
        body: BlocBuilder<EventDetailsCubit, EventDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Eroare la încărcarea detaliilor evenimentului',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'A apărut o eroare necunoscută',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EventDetailsCubit>().getEventDetails(id);
                      },
                      child: const Text('Reîncearcă'),
                    ),
                  ],
                ),
              );
            }

            if (state.event == null) {
              return const Center(child: Text('Evenimentul nu a fost găsit'));
            }

            final event = state.event!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section with Event Image/Gradient
                  _EventHeroSection(event: event),

                  // Event Title and Type
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                event.eventTypeName,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Bookmark Button
                            _BookmarkButton(eventId: event.id),
                            const SizedBox(width: 8),
                            // Share Button
                            _ShareButton(event: event),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Description Section
                  if (event.description.isNotEmpty)
                    _SectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            icon: Icons.description,
                            title: 'Descriere',
                          ),
                          const SizedBox(height: 12),
                          Html(
                            data: event.description,
                            style: {
                              "body": Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight(1.6),
                                color: AppColors.onBackground,
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ),
                              "p": Style(margin: Margins.only(bottom: 12)),
                              "h1, h2, h3, h4, h5, h6": Style(
                                fontWeight: FontWeight.bold,
                                margin: Margins.only(top: 16, bottom: 8),
                              ),
                              "ul, ol": Style(
                                margin: Margins.only(bottom: 12),
                                padding: HtmlPaddings.only(left: 20),
                              ),
                              "li": Style(margin: Margins.only(bottom: 4)),
                              "a": Style(
                                color: AppColors.primary,
                                textDecoration: TextDecoration.underline,
                              ),
                              "blockquote": Style(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColors.border,
                                    width: 4,
                                  ),
                                ),
                                padding: HtmlPaddings.only(left: 16),
                                margin: Margins.only(bottom: 12),
                                fontStyle: FontStyle.italic,
                              ),
                            },
                          ),
                        ],
                      ),
                    ),

                  // Event Information Section
                  _SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          icon: Icons.info_outline,
                          title: 'Informații Eveniment',
                        ),
                        const SizedBox(height: 16),
                        _InfoGrid(
                          children: [
                            _InfoItem(
                              icon: Icons.location_on,
                              label: 'Locație',
                              value: event.venueName,
                            ),
                            _InfoItem(
                              icon: Icons.place,
                              label: 'Adresă',
                              value: event.address,
                            ),
                            _InfoItem(
                              icon: Icons.calendar_today,
                              label: 'Data început',
                              value: _formatDateTime(event.start),
                            ),
                            _InfoItem(
                              icon: Icons.event,
                              label: 'Data sfârșit',
                              value: _formatDateTime(event.end),
                            ),
                            _InfoItem(
                              icon: Icons.schedule,
                              label: 'Program',
                              value: event.scheduleType,
                            ),
                            _InfoItem(
                              icon: Icons.attach_money,
                              label: 'Preț',
                              value: event.price,
                            ),
                            _InfoItem(
                              icon: Icons.people,
                              label: 'Capacitate',
                              value: event.capacity,
                            ),
                            if (event.age != null)
                              _InfoItem(
                                icon: Icons.person,
                                label: 'Vârstă minimă',
                                value: event.age!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contact Information Section
                  _SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          icon: Icons.contact_phone,
                          title: 'Informații Contact',
                        ),
                        const SizedBox(height: 16),
                        _ContactInfo(
                          contactPerson: event.contactPerson,
                          phoneNo: event.phoneNo,
                          email: event.email,
                        ),
                      ],
                    ),
                  ),

                  // Agenda Section
                  if (event.agenda.isNotEmpty)
                    _SectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(icon: Icons.list_alt, title: 'Agendă'),
                          const SizedBox(height: 12),
                          Html(
                            data: event.agenda,
                            style: {
                              "body": Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight(1.6),
                                color: AppColors.onBackground,
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ),
                              "p": Style(margin: Margins.only(bottom: 12)),
                              "ul, ol": Style(
                                margin: Margins.only(bottom: 12),
                                padding: HtmlPaddings.only(left: 20),
                              ),
                              "li": Style(margin: Margins.only(bottom: 4)),
                            },
                          ),
                        ],
                      ),
                    ),

                  // Theme Section
                  if (event.theme.isNotEmpty)
                    _SectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(icon: Icons.palette, title: 'Tematică'),
                          const SizedBox(height: 12),
                          Html(
                            data: event.theme,
                            style: {
                              "body": Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight(1.6),
                                color: AppColors.onBackground,
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                              ),
                              "p": Style(margin: Margins.only(bottom: 12)),
                              "ul, ol": Style(
                                margin: Margins.only(bottom: 12),
                                padding: HtmlPaddings.only(left: 20),
                              ),
                              "li": Style(margin: Margins.only(bottom: 4)),
                            },
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final months = [
        'Ian',
        'Feb',
        'Mar',
        'Apr',
        'Mai',
        'Iun',
        'Iul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final month = months[dateTime.month - 1];
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$day $month ${dateTime.year}, $hour:$minute';
    } catch (e) {
      return dateTimeString;
    }
  }
}

class _EventHeroSection extends StatelessWidget {
  final dynamic event;

  const _EventHeroSection({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.8),
            AppColors.primary.withValues(alpha: 0.6),
          ],
        ),
      ),
      child:
          event.eventImageId != null && event.eventImageId!.isNotEmpty
              ? Stack(
                children: [
                  Image.network(
                    event.eventImageId!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => _DefaultHeroContent(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : _DefaultHeroContent(),
    );
  }
}

class _DefaultHeroContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.event,
        size: 80,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  final Widget child;

  const _SectionContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<Widget> children;

  const _InfoGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    for (int i = 0; i < children.length; i += 2) {
      if (i + 1 < children.length) {
        rows.add(
          Row(
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: 12),
              Expanded(child: children[i + 1]),
            ],
          ),
        );
      } else {
        rows.add(
          Row(
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      }
      if (i + 2 < children.length) {
        rows.add(const SizedBox(height: 12));
      }
    }
    return Column(children: rows);
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onBackground.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onBackground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final String contactPerson;
  final String phoneNo;
  final String email;

  const _ContactInfo({
    required this.contactPerson,
    required this.phoneNo,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactItem(
          icon: Icons.person,
          label: 'Persoană de contact',
          value: contactPerson,
        ),
        const SizedBox(height: 12),
        _ContactItem(
          icon: Icons.phone,
          label: 'Telefon',
          value: phoneNo,
          isClickable: true,
        ),
        const SizedBox(height: 12),
        _ContactItem(
          icon: Icons.email,
          label: 'E-mail',
          value: email,
          isClickable: true,
        ),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isClickable;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onBackground.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isClickable
                            ? AppColors.primary
                            : AppColors.onBackground,
                  ),
                ),
              ],
            ),
          ),
          if (isClickable)
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.border,
            ),
        ],
      ),
    );
  }
}

// Share Button Widget
class _ShareButton extends StatelessWidget {
  final dynamic event;

  const _ShareButton({required this.event});

  void _shareEvent(BuildContext context) {
    final startDate = DateTime.parse(event.start);
    final dateFormat = DateFormat('d MMMM yyyy, HH:mm', 'ro_RO');

    final shareText = '''
${event.title}

📅 Data: ${dateFormat.format(startDate)}
📍 Locație: ${event.venueName}
${event.address}

${event.description.replaceAll(RegExp(r'<[^>]*>'), '').trim()}

Detalii: R.L. 126 Cavalerii Templului
''';

    Share.share(
      shareText,
      subject: event.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _shareEvent(context),
      icon: const Icon(Icons.share),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.inputFill,
        foregroundColor: AppColors.onBackground,
      ),
      tooltip: 'Distribuie eveniment',
    );
  }
}

// Bookmark Button Widget with local state management
class _BookmarkButton extends StatefulWidget {
  final String eventId;

  const _BookmarkButton({required this.eventId});

  @override
  State<_BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<_BookmarkButton> {
  bool _isSaved = false;
  final Set<String> _savedEvents = {}; // In a real app, this would be persisted

  @override
  void initState() {
    super.initState();
    _loadSavedStatus();
  }

  Future<void> _loadSavedStatus() async {
    // In a real app, load from SharedPreferences or database
    setState(() {
      _isSaved = _savedEvents.contains(widget.eventId);
    });
  }

  Future<void> _toggleSaved() async {
    setState(() {
      if (_isSaved) {
        _savedEvents.remove(widget.eventId);
        _isSaved = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Eveniment eliminat din salvate'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _savedEvents.add(widget.eventId);
        _isSaved = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Eveniment salvat'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
    // In a real app, persist to SharedPreferences or database
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleSaved,
      icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
      style: IconButton.styleFrom(
        backgroundColor: _isSaved
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.inputFill,
        foregroundColor: _isSaved
            ? AppColors.primary
            : AppColors.onBackground,
      ),
      tooltip: _isSaved ? 'Elimină din salvate' : 'Salvează eveniment',
    );
  }
}
