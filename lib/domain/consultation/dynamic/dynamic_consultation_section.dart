import 'package:equatable/equatable.dart';

sealed class DynamicConsultationSection extends Equatable {}

class DynamicConsultationSectionTitle extends DynamicConsultationSection {
  final String label;

  DynamicConsultationSectionTitle(this.label);

  @override
  List<Object?> get props => [label];
}

class DynamicConsultationSectionRichText extends DynamicConsultationSection {
  final String desctiption;

  DynamicConsultationSectionRichText(this.desctiption);

  @override
  List<Object?> get props => [desctiption];
}

class DynamicConsultationAccordionSection extends DynamicConsultationSection {
  final String title;
  final List<DynamicConsultationSection> expandedSections;

  DynamicConsultationAccordionSection(this.title, this.expandedSections);

  @override
  List<Object?> get props => [title, expandedSections];
}

class DynamicConsultationSectionImage extends DynamicConsultationSection {
  final String url;
  final String? desctiption;

  DynamicConsultationSectionImage({
    required this.desctiption,
    required this.url,
  });

  @override
  List<Object?> get props => [desctiption, url];
}

class DynamicConsultationSectionVideo extends DynamicConsultationSection {
  final String url;
  final String transcription;
  final int width;
  final int height;
  final String? authorName;
  final String? authorDescription;
  final DateTime? date;

  DynamicConsultationSectionVideo({
    required this.url,
    required this.transcription,
    required this.width,
    required this.height,
    required this.authorName,
    required this.authorDescription,
    required this.date,
  });

  @override
  List<Object?> get props => [
        transcription,
        url,
        width,
        height,
        authorName,
        authorDescription,
        date,
      ];
}

class DynamicConsultationSectionFocusNumber extends DynamicConsultationSection {
  final String desctiption;
  final String title;

  DynamicConsultationSectionFocusNumber({
    required this.title,
    required this.desctiption,
  });

  @override
  List<Object?> get props => [desctiption, title];
}

class DynamicConsultationSectionAccordion extends DynamicConsultationSection {
  final String title;
  final String desctiption;

  DynamicConsultationSectionAccordion({
    required this.title,
    required this.desctiption,
  });

  @override
  List<Object?> get props => [desctiption, title];
}

class DynamicConsultationSectionQuote extends DynamicConsultationSection {
  final String desctiption;

  DynamicConsultationSectionQuote(this.desctiption);

  @override
  List<Object?> get props => [desctiption];
}
