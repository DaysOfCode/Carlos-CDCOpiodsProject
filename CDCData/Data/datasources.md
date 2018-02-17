Analysis of Opiod drug overdoses data
=====================================

Carlos Santillan

<csantill@gmail.com>

<https://www.linkedin.com/in/carlos-santillan/>

CDC Dataset
-----------

Dataset: Underlying Cause of Death, 1999-2016

### Cause of Death

The National Vital Statistics System multiple cause-of-death mortality
files were used to record drug overdose deaths. Drug overdose deaths
were identified using the International Classification of Disease, Tenth
Revision (ICD-10), based on the ICD-10 underlying cause-of-death codes
X40–44 (unintentional), X60–64 (suicide), or Y10–Y14 (undetermined
intent).

-   X40-X44 Unintentional
    -   X40 (Accidental poisoning by and exposure to nonopioid
        analgesics, antipyretics and antirheumatics)
    -   X41 (Accidental poisoning by and exposure to antiepileptic,
        sedative-hypnotic, antiparkinsonism and psychotropic drugs, not
        elsewhere classified)
    -   X42 (Accidental poisoning by and exposure to narcotics and
        psychodysleptics \[hallucinogens\], not elsewhere classified)
    -   X43 (Accidental poisoning by and exposure to other drugs acting
        on the autonomic nervous system)
    -   X44 (Accidental poisoning by and exposure to other and
        unspecified drugs, medicaments and biological substances)
-   X60–64 Suicide

    -   X60 (Intentional self-poisoning by and exposure to nonopioid
        analgesics, antipyretics and antirheumatics)
    -   X61 (Intentional self-poisoning by and exposure to
        antiepileptic, sedative-hypnotic, antiparkinsonism and
        psychotropic drugs, not elsewhere classified)
    -   X62 (Intentional self-poisoning by and exposure to narcotics and
        psychodysleptics \[hallucinogens\], not elsewhere classified)
    -   X63 (Intentional self-poisoning by and exposure to other drugs
        acting on the autonomic nervous system)
    -   X64 (Intentional self-poisoning by and exposure to other and
        unspecified drugs, medicaments and biological substances)

-   Y10–Y14 Undetermined intent
    -   Y10 (Poisoning by and exposure to nonopioid analgesics,
        antipyretics and antirheumatics, undetermined intent)
    -   Y11 (Poisoning by and exposure to antiepileptic,
        sedative-hypnotic, antiparkinsonism and psychotropic drugs, not
        elsewhere classified, undetermined intent),
    -   Y12 (Poisoning by and exposure to narcotics and psychodysleptics
        \[hallucinogens\], not elsewhere classified, undetermined
        intent)
    -   Y13 (Poisoning by and exposure to other drugs acting on the
        autonomic nervous system, undetermined intent)
    -   Y14 (Poisoning by and exposure to other and unspecified drugs,
        medicaments and biological substances, undetermined intent)

The type of opioid is indicated by the following ICD-10 multiple
cause-of-death codes:

MCD - ICD-10 Codes:

-   T40.0 (Opium)
-   T40.1 (Heroin)
-   T40.2 (Other opioids)
-   T40.3 (Methadone)
-   T40.4 (Other synthetic narcotics)
-   T40.5 (Cocaine)
-   T40.6 (Other and unspecified narcotics)

### Load Monthly Data

Group By: State, Year, Month, ICD Chapter Source:

Centers for Disease Control and Prevention, National Center for Health
Statistics. Underlying Cause of Death 1999-2016 on CDC WONDER Online
Database, released December, 2017. Data are from the Multiple Cause of
Death Files, 1999-2016, as compiled from data provided by the 57 vital
statistics jurisdictions through the Vital Statistics Cooperative
Program. Accessed at <http://wonder.cdc.gov/ucd-icd10.html> on Feb 10,
2018 4:36:12 PM

-   Note: Data may not be available for all states for a give period due

Use of this data allowed under <https://wonder.cdc.gov/DataUse.html#>

CDC Data was generated from the following Query
<https://wonder.cdc.gov/controller/saved/D76/D29F799>

### Load Annual Data

Group By: State, Year, ICD Chapter

Source:

Centers for Disease Control and Prevention, National Center for Health
Statistics. Underlying Cause of Death" "1999-2016 on CDC WONDER Online
Database, released December, 2017. Data are from the Multiple Cause of
Death Files, 1999-2016, as" "compiled from data provided by the 57 vital
statistics jurisdictions through the Vital Statistics Cooperative
Program. Accessed" "at <http://wonder.cdc.gov/ucd-icd10.html> on Feb 13,
2018 11:26:09 AM"

Use of this data allowed under <https://wonder.cdc.gov/DataUse.html#>

CDC Data was generated from the following Query
<https://wonder.cdc.gov/controller/saved/D76/D30F044>

Load Geo data
-------------

Latitude and Longitude Coordinates for each state were downloaded from
<https://inkplant.com/code/state-latitudes-longitudes>


