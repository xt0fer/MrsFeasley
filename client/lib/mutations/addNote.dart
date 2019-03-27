String addNote = """
  mutation AddNote(\$noteableId: ID!) {
    addNote(input: {noteableId: \$noteableId}) {
      noteableId {
        title
      }
    }
  }
"""
    .replaceAll('\n', ' ');
