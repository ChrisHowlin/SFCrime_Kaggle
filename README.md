# SFCrime_Kaggle
Analysis of San Francisco Crime Classification dataset provided by Kaggle.com for General Assembly final project

Dataset available at https://www.kaggle.com/c/sf-crime

ControlScript
-------------

This script generates the control sample submission, which will be used as a baseline for the future submissions for the contest. The approach for this version is to compute the distribution of the crimes across the whole dataset by PdDistrict. This then gives a mapping for PdDistrict to distribution of Category probailities.

This model is really basic, as it only uses the PdDistrict as a predictor.

Kaggle score: 