function test_bug3297

% WALLTIME 00:10:00
% MEM 1gb
% DEPENDENCY
% DATA private

filename = dccnpath('/project/3031000.02/test/bug3297/testMEG001_1200hz_20170517_05.ds');

event = ft_read_event(filename);

% it only returned 3 'trial' events upon reading with the verion up to 22 May 2017
% after inlcuding type 20 as trigger, it returned 11 events
assert(numel(event)>3, 'incorrect number of events read from file');


% I looked it up in "CTF MEG(TM) File Formats" pdf, Release 5.2.1
%
% eMEGReference     0 Reference magnetometer channel
% eMEGReference1    1 Reference 1st-order gradiometer channel
% eMEGReference2    2 Reference 2nd-order gradiometer channel
% eMEGReference3    3 Reference 3rd-order gradiometer channel
% eMEGSensor        4 Sensor magnetometer channel located in head shell
% eMEGSensor1       5 Sensor 1st-order gradiometer channel located in head shell
% eMEGSensor2       6 Sensor 2nd-order gradiometer channel located in head shell
% eMEGSensor3       7 Sensor 3rd-order gradiometer channel located in head shell
% eEEGRef           8 EEG unipolar sensors not on the scalp
% eEEGSensor        9 EEG unipolar sensors on the scalp
% eADCRef           10 (see eADCAmpRef below)
% eADCAmpRef        10 ADC amp channels from HLU or PIU (old electronics)
% eStimRef          11 Stimulus channel for MEG41
% eTimeRef          12 Time reference coming from video channel
% ePositionRef      13 Not used
% eDACRef           14 DAC channel from ECC or HLU
% eSAMSensor        15 SAM channel derived through data analysis
% eVirtualSensor    16 Virtual channel derived by combining two or more physical channels
% eSystemTimeRef    17 System time showing elapsed time since trial started
% eADCVoltRef       18 ADC volt channels from ECC
% eStimAnalog       19 Analog trigger channels
% eStimDigital      20 Digital trigger channels
% eEEGBipolar       21 EEG bipolar sensor not on the scalp
% eEEGAflg          22 EEG ADC over range flags
% eMEGReset         23 MEG resets (counts sensor jumps for crosstalk pur- poses)
% eDipSrc           24 Dipole source
% eSAMSensorNorm    25 Normalized SAM channel derived through data analy- sis
% eAngleRef         26 Orientation of head localization field
% eExtractionRef    27 Extracted signal from each sensor of field generated by each localization coil
% eFitErr           28 Fit error from each head localization coil
% eOtherRef         29 Any other type of sensor not mentioned but still valid
% eInvalidType      30 An invalid sensor

