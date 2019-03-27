String readNotes = """
  query readNotes {
    viewer {
       notes {
    id
    title
    body
    tags {
      id
    }
  }
  }
"""
    .replaceAll('\n', ' ');
