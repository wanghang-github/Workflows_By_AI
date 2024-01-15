cwlVersion: v1.2
class: Workflow

# Define input parameters
inputs:
  biomart_service_url:
    type: string
    doc: "URL for Biomart service"
  emboss_service_url:
    type: string
    doc: "URL for EMBOSS SOAPLab service"
  query_species:
    type: string[]
    doc: "List of species to query (e.g., ['mouse', 'human', 'rat'])"

# Define output parameters
outputs:
  aligned_sequences:
    type: File
    outputBinding:
      glob: "output.aln"
  sequence_ids:
    type: string[]
    outputBinding:
      glob: "output.ids"

# Define workflow steps
steps:
  retrieve_sequences:
    run: biomart-tool.cwl
    in:
      service_url:  biomart_service_url
      query_species: query_species
    out:
      aligned_sequences: aligned_sequences.fasta
      sequence_ids: sequence_ids.txt

  align_sequences:
    run: emboss-tool.cwl
    in:
      service_url: emboss_service_url
      sequences: aligned_sequences
    out:
      aligned_sequences: output.aln
      sequence_ids: output.ids
      alignment_plot: alignment_plot.png

# Define workflow requirements
requirements:
  ScatterFeatureRequirement: {}

# Define resource requirements if needed
hints:
  ResourceRequirement:
    coresMin: 1
    ramMin: 1000M
