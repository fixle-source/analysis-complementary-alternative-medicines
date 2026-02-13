# Raw Data

## Data Source

This project uses data from the **European Social Survey (ESS)**.

- **Survey**: ESS Round 11 edition 4.1
- **Year**: 2023
- **Citation**: European Social Survey European Research Infrastructure (ESS ERIC) (2026) ESS11 - integrated file, edition 4.1 [Data set]. Sikt - Norwegian Agency for Shared Services in Education and Research
- **DOI**: 10.21338/ess11e04_1

## Data Access

The ESS data is freely available but requires registration.

### How to obtain the data:

1. Go to https://www.europeansocialsurvey.org/data/
2. Register for a free account
3. Download ESS Round 11 edition 4.1 integrated file
4. Select **all countries**
5. Download format: CSV
6. Place the downloaded file in this `data/raw/` directory

**Filename expected**: ESS11e04_1.csv

## Variables Used

This analysis uses the following ESS variables:

### Healthcare utilization
- `trhltacu` to `trhltmt`: Complementary and alternative medicine (CAM) treatments (12 binary variables)
- `dshltgp`: General practitioner consultation
- `dshltms`: Medical specialist consultation

### Healthcare access barriers
- `medtrun`, `medtrnp`, `medtrnt`, `medtrnl`, `medtrwl`, `medtrnaa`: Access difficulties variables

### Health outcomes
- `health`: Subjective health status
- `hlthhmp`: Activity limitations
- `fltdpr`, `flteeff`, `slprl`, `wrhpp`, `fltlnl`, `enjlf`, `fltsd`, `cldgng`: CES-D depression items
- `hltprbn`, `hltprpa`, `hltprpf`: Musculoskeletal pain variables

### Values (Portrait Values Questionnaire)
- `ipcrtiva`, `impdiffa`, `ipadvnta`, `impenva`, `iphlppla`, `imptrada`, `impsafea`, `impricha`

### Sociodemographic controls
- `gndr`, `agea`, `eisced`, `hinctnta`, `cntry`, `domicil`

### Weights
- `anweight`: Analysis weight
- `pspwght`, `pweight`: Population size weights for cross-country comparisons

## Data Restrictions

**Important**: Raw ESS data files are **not included** in this repository due to:
- ESS Terms of Use requirements
- File size

Users must download the data independently following the instructions above.

## Data Processing

The raw data is processed using the script `../scripts/01_data_preparation.R` which:
- Loads the raw ESS file
- Selects relevant variables
- Handles missing values
- Creates derived variables (CAM binary composite, CES-D score, access difficulties score)
- Exports processed data to `../data/processed/`

## License and Citation

The European Social Survey is distributed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

When using this data, cite:
European Social Survey European Research Infrastructure (ESS ERIC) (2026) ESS11 - integrated file, edition 4.1 [Data set]. Sikt - Norwegian Agency for Shared Services in Education and Research. https://doi.org/10.21338/ess11e04_1.

## Contact

For questions about data access: contact the ESS team at https://www.europeansocialsurvey.org/contact/

For questions about this analysis: https://github.com/fixle-source/
