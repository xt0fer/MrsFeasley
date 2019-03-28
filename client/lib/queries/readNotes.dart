String readNotes = """
query readNotes {
  notes {
    id
    title
    body
    updatedAt
    tags {
      id
    	}
  	}
}
"""
    .replaceAll('\n', ' ');
