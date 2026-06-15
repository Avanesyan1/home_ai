import 'package:home_ai/features/redesign/domain/entities/redesign_category.dart';
import 'package:home_ai/features/redesign/domain/entities/redesign_draft.dart';

abstract final class RedesignPromptBuilder {
  static String build(RedesignDraft draft) {
    final style = _styleDescription(draft.style!.id);
    final palette = _paletteDescription(draft.palette!.id);
    final wishes = draft.wishes.trim();

    final editPrompt = switch (draft.category) {
      RedesignCategory.interior =>
        'Redesign this interior room in a $style interior design style, '
            'using a $palette. '
            'Restyle the furniture, walls, decor and lighting to match the style. '
            'Preserve the exact room geometry, window and door positions, '
            'camera angle and perspective.',
      RedesignCategory.exterior =>
        'Redesign this building exterior in a $style architectural style, '
            'using a $palette for the facade. '
            'Restyle the facade materials, finishes and landscaping to match the style. '
            'Preserve the exact building structure, proportions, '
            'camera angle and perspective.',
      RedesignCategory.garden =>
        'Redesign this garden and outdoor space in a $style landscape style, '
            'using a $palette. '
            'Restyle the plants, paths, furniture and decor to match the style. '
            'Preserve the exact layout boundaries, camera angle and perspective.',
      RedesignCategory.floor =>
        'Replace only the floor in this interior with $style flooring, '
            'using a $palette. '
            'Keep the walls, furniture, decor, lighting, '
            'camera angle and perspective exactly the same.',
    };

    final buffer = StringBuffer(
      'Generate a single photorealistic, high-resolution edited image. '
      '$editPrompt '
      'The result must look like a real photograph, not a drawing or render. '
      'Return only the edited image, with no text.',
    );

    if (wishes.isNotEmpty) {
      buffer.write(' Also apply these specific requests: $wishes.');
    }

    return buffer.toString();
  }

  static String _styleDescription(String id) {
    return switch (id) {
      'modern' => 'modern',
      'minimalist' => 'minimalist',
      'scandinavian' => 'Scandinavian',
      'industrial' => 'industrial',
      'classic' => 'classic',
      'luxury' => 'luxury',
      'mediterranean' => 'Mediterranean',
      'rustic' => 'rustic',
      'contemporary' => 'contemporary',
      'zen' => 'Japanese zen',
      'tropical' => 'tropical',
      'english' => 'English country garden',
      'natural' => 'natural',
      'hardwood' => 'natural hardwood',
      'laminate' => 'laminate wood',
      'tile' => 'ceramic tile',
      'marble' => 'polished marble',
      'concrete' => 'polished concrete',
      'carpet' => 'soft carpet',
      _ => id,
    };
  }

  static String _paletteDescription(String id) {
    return switch (id) {
      'neutral' => 'neutral color palette of soft greys and off-whites',
      'warm' => 'warm color palette of beige, terracotta and brown tones',
      'cool' => 'cool color palette of blue and teal tones',
      'monochrome' => 'monochrome black, white and grey color palette',
      'natural' => 'natural earthy color palette of greens and warm browns',
      _ => '$id color palette',
    };
  }
}
