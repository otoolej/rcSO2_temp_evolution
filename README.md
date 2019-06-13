# Code to accompany paper "Monitoring cerebral oxygenation of preterm infants using a neonatal specific sensor"


Matlab and R code used to in:

`Kenosi M, O’ Toole JM, Hawkes GA, Hutch W, Low E, Wall M, Boylan GB, Ryan CA, Dempsey EM,
Monitoring cerebral oxygenation of preterm infants using a neonatal specific sensor,
Journal of Perinatology, 2018, 38(3):264.` [10.1038/s41372-017-0007-5](https://doi.org/10.1038/s41372-017-0007-5)

Code only. No data.

Please cite the above reference if using this code to generate new results. 

# Mixed-effects model

The mixed-effects model is developed in _R_ (version
3.3.1, [The R Foundation of Statistical Computing](http://www.r-project.org)) using the
_lme4_ package (version 1.1-10). Script [gen\.MixedEffectsModel\.R](gen.MixedEffectsModel.R)
details model selection and estimation of fixed coefficients.


# Hypoxia and hyperoxia measures for rcSO<sub>2</sub> 

We define hypoxia as the total area <55/60% rcSO<sub>2</sub> and hyperoxia as the total
area >85/90% rcSO<sub>2</sub>, using the lower limits (i.e. 55% and 85%) for the extremely
preterm infants and the upper limits (i.e. 60% and 90%) for the very preterm infants. This
is generated in Matlab (version
R2013b, [The Mathworks](http://www.mathworks.co.uk/products/matlab/)).  See file
for [outcome\_hypoxia\_hyperoxia.m](outcome_hypoxia_hyperoxia.m) for more details.  Run in
Matlab as


```matlab
%% generate placeholder data (colour Gaussian noise for rcSO2) for 120 babies:
all_data=gen_random_NIRS_data(120);

%% estimate area above/below thresholds and compare between the 3 outcome groups:
outcome_hypoxia_hyperoxia(all_data);
```

Above function assumes that the array-structure `all_data` is of the form:

field name | explanation
------------ | -------------
baby\_ID | string for baby identifier 
DOB\_time | time and date of birth (e.g. '14-Sep-2015 01:16:00')
GA | gestational age (in days)
outcome | either 1 = normal; 2 = mild; 3 = moderate/severe
nirs\_time | time (vector) for rcSO2 (in seconds)
nirs\_data | rcSO2 (vector)



# Licence

```
Copyright (c) 2017, John M. O' Toole, University College Cork
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

  Neither the name of the University College Cork nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```


# Contact

John M. O' Toole

Neonatal Brain Research Group,  
Irish Centre for Fetal and Neonatal Translational Research (INFANT),  
Department of Paediatrics and Child Health,  
Room 2.19 Paediatrics Bld, Cork University Hospital,  
University College Cork,  
Ireland

- email: j.otoole AT ieee.org

