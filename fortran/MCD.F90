      module MCD_var
      
      implicit none
      

! CONSTANTS

!     information and error messages will be written to output if
!     output_message is .true. Switch to .false. for a "silent" mode

      logical, parameter ::  output_messages = .true.
      
!     default unit to which messages will be sent:
!     typically out=6 implies screen, other (positive) values (except 0
!     which is sometimes preconected to standard error, and 5, which is
!     standard input) should be OK (messages will be sent to file 'fort.out',
!     unless an open(out, file="myfilename") call was issued prior to the
!     very first call to call_mcd

      integer, parameter ::  out = 6
      
      
!      Gravity/radius of Mars
       
      real,parameter :: g0=3.7257964  ! reference gravitational acceleration (m/s2)
      real,parameter :: a0=3396.E3    ! reference distance at which g=g0 (m)    

      ! Reference pressure (Pa)      
      real, parameter :: pref = 610.
      
      ! Solar constant (solar flux at 1UA (W/m2))
      real, parameter :: solar_const = 1370. 
     

!     dimension of mean and std. dev.values  in longitude, latitude, 
!     sigma levels and database universal time

      integer, parameter ::  dimlon  =  64
      integer, parameter ::  dimlat  =  49
      integer, parameter ::  dimlevs =  73
      integer, parameter ::  dimuti  =  12
         
!     dimensions of EOF values in longitude, latitude, numbers of EOFs 
      
      integer, parameter :: dimloneo  = 32
      integer, parameter :: dimlateo  = 24
      integer, parameter :: dimnevecs = 200
      integer, parameter :: dimeoday  = 669      
      
!     range of latitude, longitude  and time for mean 
!     and std. dev. values
      
      real, parameter :: lonmin = -180.
      real, parameter :: lonmax =  174.375
      real, parameter :: latmin = -90.     
      real, parameter :: latmax =  90.

!     range of latitude, longitude, number of EOFs and time for EOFs values 

      real, parameter :: lonmineo = -180.0
      real, parameter :: lonmaxeo =  168.75
      real, parameter :: latmineo = -86.25
      real, parameter :: latmaxeo =  86.25
      
      real, parameter :: daymineo = 1.0
      real, parameter :: daymaxeo = 669.0


!     step of grid in longitude and latitude for mean and std. dev. values

      real, parameter :: deltalon = 5.625
      real, parameter :: deltalat = 3.75

!     step of grid in longitude and latitude for EOFs values

      real, parameter :: deltalateo = 7.5
      real, parameter :: deltaloneo = 11.25
      
!     number of 2d, low and up variables

      integer, parameter ::  nbvar2d  = 28  ! number of 2D variables
      integer, parameter ::  nbvarlow = 21  ! number of 3D variables in "low" file
      integer, parameter ::  nbvarup  = 21  ! number of 3D variables in "up" file


      integer, parameter ::  nbsd2d  = 3    ! number of 2D RMS variables
      integer, parameter ::  nbsdlow = 5    ! number of 3D RMS variables in "low" file
      integer, parameter ::  nbsdup  = 5    ! number of 3D RMS variables in "up" file
      
      integer, parameter ::  nbvar3d = 21   ! total number of 3D variables
      integer, parameter ::  nbcom   = 21   ! number of 3D variables both in "low" and "up" files

      integer, parameter ::  nbsd3d  = 5    ! total number of 3D RMS variables
      integer, parameter ::  nbcomsd = 5    ! number of 3D RMS variables both in "low" and "up" files

! Layer below which the mean is done between 3 runs.
     
      integer, parameter ::  low = 53
      integer, parameter ::  up  = 20
      
! Aerodynamic roughness length (for Boundary layer behavior of horizontal
!  velocities between ground and 1st GCM level).

! COMMON

      common /orogra/ taborog,tabsubstd,tabareo,tabz0,z_0,tabti,thermal_inertia,tabga,ground_albedo,tabwc,water_cap
      common /moyenne/ var_2d,var_2d2,var_3d,var_3d2
      common /rms/ varrms2d,varrms2d2,varrms3d,varrms3d2,vararms3d,vararms3d2
      common /eofs/ tabeonormu,tabeonormv,tabeonormt,tabeonormp,tabpcsmth,tabpc,tabeops,tabeot,tabeou,tabeov       
!     &     tabeonormr,tabpcsmth,tabpcvar,tabeops,tabeot,tabeorho,


!     GCM orographic data array
      real taborog(dimlon,dimlat,1)
      
!     GCM areoid data array
      real tabareo(dimlon,dimlat,1)
      
!     GCM orographic variance array
      real tabsubstd(dimlon,dimlat,1)
      
!     GCM roughness length array
      real tabz0(dimlon,dimlat,1)
      real z_0

!     GCM surface thermal inertia
      real tabti(dimlon,dimlat,1)
      real thermal_inertia      
      
!     GCM bare ground albedo
      real tabga(dimlon,dimlat,1)
      real ground_albedo       

!     GCM perennial surface water ice
      real tabwc(dimlon,dimlat,1)
      real water_cap   

! 2D fields: (see loadvar and vard2d routines)
! ---------
! tsurf              ! 1. surface temperature
! ps                 ! 2. surface pressure
! co2ice             ! 3. co2ice cover
! fluxsurf_lw        ! 4. Thermal IR radiative flux to surface
! fluxtop_lw         ! 5. Thermal IR radiative flux to space
! fluxsurf_dn_sw     ! 6. Incident Solar IR radiative flux to surface
! fluxsurf_dir_dn_sw ! 7. Direct incoming Solar IR radiative flux to surface
! fluxsurf_up_sw     ! 8. Reflected Solar IR radiative flux at surface
! fluxtop_dn_sw      ! 9. Incident Solar IR radiative flux at top of the atmosphere
! fluxtop_up_sw      !10. Reflected Solar IR radiative flux to space
! tauref             !11. Dust optical depth
! col_h2ovapor       !12. H2O vapour column
! col_h2oice         !13. H20 ice column
! zmax               !14. maximum height reached by thermals (m)
! hfmax              !15. maximum vertical turbulent heat flux in thermals (K.m/s)
! wstar              !16. free convection velocity scale from thermals (m/s)
! c_co2              !17. CO2 column
! c_co               !18. CO column
! c_o                !19. O column
! c_o2               !20. O2 column
! c_o3               !21. O3 column
! c_h                !22. H column
! c_h2               !23. H2 column
! c_n2               !24. N2 column
! c_ar               !25. Ar column
! c_elec             !26. electron column
! c_he               !27. Helium column
! h2oice             !28. H2O surface frost

      real  var_2d(dimlon,dimlat,dimuti,nbvar2d)  ! previous season
      real  var_2d2(dimlon,dimlat,dimuti,nbvar2d) ! next season

! 3D fields         (see loadvar and profi routines)

      real  var_3d(dimlon,dimlat,dimlevs,dimuti,nbvar3d)  ! previous season
      real  var_3d2(dimlon,dimlat,dimlevs,dimuti,nbvar3d) ! next season
        
! RMS value arrays : surface pressure, surface temperature
! temperature, density, zonal and meriodional wind components

      real  varrms2d(dimlon,dimlat,nbsd2d)
      real  varrms2d2(dimlon,dimlat,nbsd2d)
      real  varrms3d(dimlon,dimlat,dimlevs,nbsd3d) 
      real  varrms3d2(dimlon,dimlat,dimlevs,nbsd3d) 
! Altitude-wise RMS for temperature, density, winds and pressure
      real  vararms3d(dimlon,dimlat,dimlevs,nbsd3d+1) 
      real  vararms3d2(dimlon,dimlat,dimlevs,nbsd3d+1) 

!     arrays related to EOFs
!     normalisation factors for zonal wind, meriodional wind, temperature
!     pressure and density

      real  tabeonormu(dimlateo)
      real  tabeonormv(dimlateo)
      real  tabeonormt(dimlateo)
      real  tabeonormp(dimlateo)
      
!      real  tabeonormr(dimlateo)
      real  tabpc(dimlateo,dimeoday,dimnevecs)
      
!     smoothed PCs
      real  tabpcsmth(dimlateo,dimeoday,dimnevecs)
      
!     PCs variance
!      real  tabpcvar(dimlateo,dimeoday,dimnevecs)
!     EOFS for surface pressure, temperature, density, zonal wind
!     and meriodional wind

      real  tabeops(dimloneo,dimlateo,dimnevecs)
      real  tabeot(dimloneo,dimlateo,dimlevs,dimnevecs)
!      real  tabeorho(dimloneo,dimlateo,dimlevs,dimnevecs)
      real  tabeou(dimloneo,dimlateo,dimlevs,dimnevecs)
      real  tabeov(dimloneo,dimlateo,dimlevs,dimnevecs)
       
!     EOFs time-average values (mean component) of zonal wind,
!     meridional wind, temperature and surface pressure
!      real  tabeouave(dimloneo,dimlateo,dimlevs)
!      real  tabeovave(dimloneo,dimlateo,dimlevs)
!      real  tabeotave(dimloneo,dimlateo,dimlevs)
!      real  tabeopsave(dimloneo,dimlateo)
      

! c_x column of x, h2oice=seasonal h2o water on the surface
!      


      character*50, parameter :: varname2d(nbvar2d) = (/'tsurf             ', 'ps                ', 'co2ice            ',   &
                                                        'fluxsurf_lw       ', 'fluxtop_lw        ', 'fluxsurf_dn_sw    ',   &
                                                        'fluxsurf_dir_dn_sw', 'fluxsurf_up_sw    ', 'fluxtop_up_sw     ',   &
                                                        'fluxtop_dn_sw     ', 'tau_pref_gcm      ', 'col_h2ovapor      ',   &
                                                        'col_h2oice        ', 'zmax              ', 'hfmax             ',   &
                                                        'wstar             ', 'c_co2             ', 'c_co              ',   &
                                                        'c_o               ', 'c_o2              ', 'c_o3              ',   &
                                                        'c_h               ', 'c_h2              ', 'c_n2              ',   &
                                                        'c_ar              ', 'c_elec            ', 'c_he              ',   &
                                                        'h2oice            '/) 
!
! reffdust=dust effective radius
! reffice=water ice effective radius
      character*50, parameter :: varname3d(nbvar3d)= (/'temp        ', 'u           ', 'v           ',   &
                                                       'w           ', 'rho         ', 'vmr_h2ovapor',   &
                                                       'vmr_h2oice  ', 'vmr_co2     ', 'vmr_co      ',   &
                                                       'vmr_o       ', 'vmr_o2      ', 'vmr_o3      ',   &
                                                       'vmr_h       ', 'vmr_h2      ', 'vmr_n2      ',   &
                                                       'vmr_ar      ', 'vmr_elec    ', 'vmr_he      ',   &
                                                       'dustq       ', 'reffdust    ', 'reffice     '/)
!
! ma3d() contains molecular weight of species (from varname3d) contributing 
! in the atmospheric pressure and used for extrapolation above top layer 
! (set to -1.0 if not contributing). 
!
      real, parameter  :: ma3d(nbvar3d) =  (/-1.0,        -1.0,         -1.0,   &
                                             -1.0,        -1.0,         18.0,   &
                                             -1.0,        44.0,         28.0,   &
                                             16.0,        32.0,         48.0,   &
                                              1.0,         2.0,         28.0,   &
                                             40.0,        -1.0,          4.0,   &
                                             -1.0,        -1.0,         -1.0/)      
            
      end module MCD_var
      
      
      
      
      module MCD 
      
           
      implicit none
      
      
      contains 
      
      subroutine call_mcd(zkey,xz,xlon,xlat,hireskey,datekey,xdate,localtime,dset,scena, &
                          perturkey,seedin,gwlength,extvarkeys,                          &
                          pres,dens,temp,zonwind,merwind,meanvar,extvar,seedout,ier)

       
      use MCD_var, only : dimlon, dimlat, dimlevs, nbvar2d, nbvar3d, var_2d, var_3d,     &
                          a0, g0, ground_albedo, thermal_inertia, water_cap, z_0,        &
                          pref, solar_const, out, output_messages
                                                    
     
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! Purpose:
! =======
!     call_mcd is a fortran subroutine which extracts and computes
!     meteorogical variables from the Mars Climate Database
!
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! Version:
! =======
!     6.1.2 10/24 Bug fix : short wave fluxes are set to zero when negative 
!                 due to rescale coefficient for extvar(29) to extvar(33) (TP+EM)
!     6.1.2 10/24 Pbl parameter routine updated to be the same as the PCM (LL)
!     6.1.1 02/24 Bug fix for computation of Daily mean dust deposition rate
!                 extvar(43) (EM)
!     6.1 04/23 Bug fixed when MCD is called with everything fixed (lon,lat,time) 
!               except Ls : no seasonal interpolation was done (EM+TP)
!     6.1 05/22 MCDv6.1 release : database based on new GCMv6 version
!               Scenarios MY34 and MY35 available
!               call_mcd is now inside a module MCD.F90 (TP)
!               correction for extrapolation of rho (and rho_rms) (TP)
!               remove patch correction for surface water ice, not needed anymore (TP)
!               Change exravariables order (FF+EM+TP+AB)
!               Add incident solar flux at the top of the atmosphere (EM+TP)
!               Add reflected solar flux on surface (EM+TP)
!               Direct incoming solar flux to compute flux on local slope is now read on data files (TP+EM)  
!               Add surface albedo, thermal inertia and watercap (now read in mountain.nc) (EM+TP)            
!               Add potential temperature (TP)
!               Remove unused extra-variables (TP)
!               Put Insight as reference for HR surface pressure (TP)
!               No more VL3 reference pressure used for storm, Insight is used too (TP)
!               Removed VL3.ls and Insight.ls (and VL1.ls) files because harmonics equations are coded in calc_factcor routine (TP)
!               Add intent(in/out) for subroutines/functions arguments (TP)
!               Replace all hard coded gravity and radius of areoid by variables (parameter) (TP)
!               Replace all 'include netcdf' by 'use netcdf' and adapt nf functions used (TP)
!               Rescale all solar flux with factor : fluxtop_dn_sw_inst/fluxtop_dn_sw (TP+FF)
!     6.1 alpha : 07/21 : Dust scenarios, Slope winds, solar irradiance on slopes (TP)
!     6.0 11/19 MCDv6.0 release
!     5.3 05/20 patch to fix bug in surface water ice (FF)
!     5.3 09/18 Added MY33 scenario
!     5.3 07/17 New EUV scenarios and improved gravity waves perturbations,
!               Improved extrapolation above ~250km
!               And added He outputs and a Mars Year 32 scenario
!     5.2 02/15 Added scenarios 24 to 31 for Mars Years 24 to 31
!     5.2 02/15 MCDv5.2 added output of solar zenit angle, Sun-Mars distance,
!               local mean solar time; improved surface layer computations
!     5.2 01/15 MCDv5.2 release with corrected vertical velocity and TEC
!     5.1 05/14 MCDv5.1 release ; improved dust storm high res. with "VL3"
!     5.0 03/14 added near-surface noise perturbation model 
!     5.0 12/12 new scenarios and more outputs and improved EOF perturbations
!     4.3 04/08 new improved large scale (EOF) perturbations model
!     4.2 02/08 improved GW perturbations behaviour near surface (grwpb.F)
!     4.2 02/08 fixed 2 minor bugs (random seed initialization & getsi.F)
!     4.2 02/08 implemented EOF perturbations interpolations
!     4.2 02/08 added zkey=5 option 
!     4.2 06/07 various minor bug fixes
!     4.2 03/07 added interpolation for temp. and winds below first layer
!     4.2 03/07 added altitude-wise RMS
!     4.2 12/06 changed "atmemcd" routine to "call_mcd"; added high resolution
!     4.1 03/06 improved time routines (orbit,mars_ltime,sol2ls,ls2sol)
!     4.1 02/05 add many new output variables.  
!     4.0 12/04 add many new output variables.  
!     4.0 09/04 height calculation in atmemcd (not in test_emcd anymore)      
!     4.0 09/04 choice of vertical coordinates, input output 
!     4.0 09/04 R changes with altitude 
!     4.0 06/04 add variables, add RMS, up and low atmosphere
!     3.2 03/04 saved variables, seasonal interpolation, variable gravity
!     3.1 05/01 bug fixes and improved interpolations
!     3.0 02/01 - Major MCD release based on earlier code
!     2.3 05/09/00
!     2.2 23/03/00
!
! Authors:
! =======
!     v6.1 alpha : Implementation of high temporal resolution dust scenarios
!          Improved dust deposition rate, slope inclination and orientation,
!          solar irradiance on slopes and high resolution slope winds -- TP
!     v5.0 Implemented new scenarios and possibility to select which
!          extra variables will be computed -- EM
!     v4.3 Implemented improved large scale perturbations model -- EM
!     v4.2 Changed argument list; implemented high resolution and altitude-wise
!          RMS, and many other small changes  -- EM
!     v4.1 Improved Earth to Mars date conversion + local time -- EM
!     v4.1 Final version with further new variables, bug fixed, EOF -- FF
!     v4.0 version with new variables, bug fixed, EOF -- FF
!     v4.0 combining low and up atmosphere, variables added --
!          min, mean and max solar scenario for thermosphere --
!          choice of vertical coordinates, flag zkey, zareoid, zsurface, 
!          zradius,zpressure in input output --       
!          altitude in meters everywhere -- KD, FF
!     v3.2 Variables saved in subroutines, seasonal interpolation added -- SJB
!          Gravity allowed to vary with height in hydrostatic eqn  -- SRL
!
!     v3.1 Bugs fixed, new ls2sol routine and various improvements
!     to interpolation above model top, especially for EOFs -- SRL
!
!     Major updates for v3.0 MCD -- SRL + FF
!       See Changes file for more information.
!
!     Modifications for v2.3 MCD -- SRL
!
!     Derived from code for version 2 by C. HOURTOLLE
!
!
! Arguments (inputs):
! ==================
!   zkey  : <integer>   type of vertical coordinate xz
!                       1 = radius from centre of planet (m)
!                       2 = height above areoid (m) (MOLA zero datum)
!                       3 = height above surface (m)
!                       4 = pressure level (Pa)
!                       5 = altitude above mean Mars Radius(=3396000m) (m)
!   xz    : <real> vertical coordinate (m or Pa, depends on zkey)
!   xlon  : <real> longitude (degrees east)
!   xlat  : <real> latitude (degrees north)
!   hireskey: <integer> flag to switch to high resolution topography
!                    0 = use GCM resolution
!                    1 = switch to high resolution topography
!   datekey: <integer>    type of input date
!                    0 = "Earth time": xdate is given in Julian days
!                                      (localtime must be set to zero)
!                    1 = "Mars date": xdate is the value of Ls
!   xdate : <double precision> date 
!                      IF datekey = 0 : Earth julian date
!                      IF datekey = 1 : Value of Ls (in degrees)
!   localtime : <real> local time (in martian hours) at longitude xlon
!              ONLY USED IF datekey=1 (must be set to 0 if datekey=0)
!   dset  : <character*(*)>    data set
!                              One or more blanks to get the default,
!                              or full directory path of MCD data required
!                              including trailing slash (e.g. '/dir/path/'),
!                              or a link to a directory (e.g. 'MCD_DATA/').
!                              Default is link MCD_DATA in working directory.
!   scena : <integer>          scenario
!                             1 = Climatology ave solar
!                             2 = Climatology min solar
!                             3 = Climatology max solar
!                             4 = dust storm tau=5 (dark dust) min solar           
!                             5 = dust storm tau=5 (dark dust) ave solar           
!                             6 = dust storm tau=5 (dark dust) max solar           
!                             7 = warm scenario - dusty, max solar        
!                             8 = cold scenario - low dust, min solar
!                            24 = Mars Year 24, with associated solar EUV
!                            25 = Mars Year 25, with associated solar EUV
!                            26 = Mars Year 26, with associated solar EUV
!                            27 = Mars Year 27, with associated solar EUV
!                            28 = Mars Year 28, with associated solar EUV
!                            29 = Mars Year 29, with associated solar EUV
!                            30 = Mars Year 30, with associated solar EUV
!                            31 = Mars Year 31, with associated solar EUV
!                            32 = Mars Year 32, with associated solar EUV
!                            33 = Mars Year 33, with associated solar EUV
!                            34 = Mars Year 34, with associated solar EUV
!                            35 = Mars Year 35, with associated solar EUV

!   perturkey: <integer>  perturbation type
!             1: none
!             2: large scale : 'seedin' is seed or signals reseting the
!                EOF perturbations if changed between calls to CALL_MCD
!             3: small scale : 'seedin' is seed or signals reseting the
!                GW perturbations if changed between calls to CALL_MCD
!             4: large and small scale : does both 2 and 3 above
!             5: add 'seedin' times the standard deviation
!                (seedin must not be greater than 4 or less than -4)
!   seedin: <real> 
!           IF perturkey=2,3,4: seed for random number generation
!                               changes in seedin between subsequent calls
!                               trigger reseeding and regeneration of
!                               perturbations
!           IF perturkey=5: coefficient by which standard deviations should
!                           be multiplied before being added to mean values
!   gwlength : <real>  for small scale (ie: gravity wave) perturbations;
!                   gwlength= vertical wavelength (lamda) of gravity wave perturbation (m)
!                             set to zero to get default (16000m). 
!                             horizontal wavelength (lamda_D) is proportional to the
!                             vertical one (lamda_D = 10 x lamda)
!   extvarkeys  : <integer> array output type
!                   extvar(i) = 0 : don't compute and output extvar(i)
!                   extvar(i) = 1 : compute and output extvar(i)
!
! Arguments (outputs):
! ===================


!   pres    : <real> atmospheric pressure (Pa)
!   dens    : <real> atmospheric density (kg/m^3)
!   temp    : <real> atmospheric temperature (K)
!   zonwind : <real> zonal wind component (m/s) (East-West)
!   merwind : <real> meridional wind component (m/s) (North-South)


!   meanvar : <real> mean unperturbed values (array of dimension nmeanvar=5)

!               meanvar(1)= mean pressure
!               meanvar(2)= mean density
!               meanvar(3)= mean temperature
!               meanvar(4)= mean zonal wind component
!               meanvar(5)= mean meridional wind component



!   extvar : <real>  extra variables array (of dimension nextvar=100)


!             extvar(1) = Radial distance from planet center (m)
!             extvar(2) = Altitude above areoid (Mars geoid) (m)
!             extvar(3) = Altitude above local surface (m)
!             extvar(4) = orographic height (m) (surface altitude above areoid)
!             extvar(5) = GCM orography (m)
!             extvar(6) = Local slope inclination (deg) (if hireskey=1)
!             extvar(7) = Local slope orientation (deg) (0 deg Northward) (if hireskey=1)



!             extvar(8) = Sun-Mars distance (in Astronomical Unit AU)
!             extvar(9) = Ls, solar longitude of Mars (deg)
!             extvar(10)= LST: Local true solar time (hrs)
!             extvar(11)= LMT: Local mean time (hrs) at sought longitude (LMT is only computed for Earth date input)
!             extvar(12)= Universal solar time (LST at lon=0) (hrs)
!             extvar(13)= Solar zenith angle (deg)
 
                  

!             extvar(14)= Surface temperature (K)
!             extvar(15)= Surface pressure (Pa) (high resolution if hireskey=1)
!             extvar(16)= GCM surface pressure (Pa)
!             extvar(17)= Potential temperature (K) (reference pressure=610Pa)
!             extvar(18)= Vertical wind component (m/s) (Up-Down)
!             extvar(19)= Zonal slope wind component (m/s)      (if hireskey=1)
!             extvar(20)= Meridional slope wind component (m/s) (if hireskey=1)



!             extvar(21)= Surface pressure RMS day to day variations (Pa)
!             extvar(22)= Surface temperature RMS day to day variations (K)
!             extvar(23)= Atmospheric pressure RMS day to day variations (Pa)
!             extvar(24)= Density RMS day to day variations (kg/m^3)
!             extvar(25)= Temperature RMS day to day variations (K)
!             extvar(26)= Zonal wind RMS day to day variations (m/s)
!             extvar(27)= Meridional wind RMS day to day variations (m/s)
!             extvar(28)= Vertical wind RMS day to day variations (m/s)



!             extvar(29)= Incident solar flux at top of the atmosphere (W/m2)
!             extvar(30)= solar flux reflected to space (W/m2)
!             extvar(31)= Incident solar flux on horizontal surface (W/m2)
!             extvar(32)= Incident solar flux on local slope (W/m2) (if hireskey=1)
!             extvar(33)= Reflected solar flux on horizontal surface (W/m2)
!             extvar(34)= thermal IR flux to space (W/m2)
!             extvar(35)= thermal IR flux on surface (W/m2)


!             extvar(36)= GCM surface roughness length z0 (m)
!             extvar(37)= GCM surface thermal inertia
!             extvar(38)= GCM surface bare ground albedo 



!             extvar(39)= Monthly mean dust column visible optical depth above surface
!             extvar(40)= Daily mean dust column visible optical depth above surface
!             extvar(41)= Dust mass mixing ratio (kg/kg)
!             extvar(42)= Dust effective radius (m)
!             extvar(43)= Daily mean dust deposition rate on horizontal surface (kg m-2 s-1)



!             extvar(44)= Monthly mean surface CO2 ice layer (kg/m2)
!             extvar(45)= Monthly mean surface H2O layer (kg/m2) (non perennial frost)
!             extvar(46)= GCM perennial surface water ice (0 or 1)
!             extvar(47)= Water vapor column (kg/m2)
!             extvar(48)= Water vapor vol. mixing ratio (mol/mol)
!             extvar(49)= Water ice column (kg/m2)
!             extvar(50)= Water ice mixing ratio (mol/mol)
!             extvar(51)= Water ice effective radius (m)



!             extvar(52)= Convective Planetary Boundary Layer (PBL) height (m)
!             extvar(53)= Max. upward convective wind within the PBL (m/s)
!             extvar(54)= Max. downward convective wind within the PBL (m/s)
!             extvar(55)= Convective vertical wind variance at level z (m2/s2)
!             extvar(56)= Convective eddy vertical heat flux at level z (m/s/K)
!             extvar(57)= Surface wind stress (Kg/m/s2)
!             extvar(58)= Surface sensible heat flux (W/m2) (<0 when flux from surf to atm.)



!             extvar(59)= Air heat capacity Cp (J kg-1 K-1)
!             extvar(60)= gamma=Cp/Cv Ratio of specific heats
!             extvar(61)= R: Molecular gas constant (J K-1 kg-1)
!             extvar(62)= Air viscosity estimation (N s m-2)
!             extvar(63)= Scale height H(p) (m)



!             extvar(64)= [CO2] volume mixing ratio (mol/mol)
!             extvar(65)= [N2] volume mixing ratio  (mol/mol)
!             extvar(66)= [Ar] volume mixing ratio  (mol/mol)
!             extvar(67)= [CO] volume mixing ratio  (mol/mol)
!             extvar(68)= [O] volume mixing ratio   (mol/mol)
!             extvar(69)= [O2] volume mixing ratio  (mol/mol)
!             extvar(70)= [O3] volume mixing ratio  (mol/mol)
!             extvar(71)= [H] volume mixing ratio   (mol/mol)
!             extvar(72)= [H2] volume mixing ratio  (mol/mol)
!             extvar(73)= [He] volume mixing ratio  (mol/mol)



!             extvar(74)= CO2 column (kg/m2)
!             extvar(75)= N2 column  (kg/m2)
!             extvar(76)= Ar column  (kg/m2)
!             extvar(77)= CO column  (kg/m2)
!             extvar(78)= O column   (kg/m2)
!             extvar(79)= O2 column  (kg/m2)
!             extvar(80)= O3 column  (kg/m2)
!             extvar(81)= H column   (kg/m2)
!             extvar(82)= H2 column  (kg/m2)
!             extvar(83)= He column  (kg/m2)



!             extvar(84)= Electron number density (particules/cm3)
!             extvar(85)= Total electonic content (TEC) (particules/m2)


!             85-100 : not used (set to zero)        
        

!   seedout : <real> current value of the seed of the random number generator
!    ier  : <integer> error flag
!     0 = OK
!     1 = wrong vertical coordinate flag (zkey)
!     2 = wrong dust scenario (scena)
!     3 = wrong value for perturbation flag (perturkey)
!     4 = wrong value for high resolution flag (hireskey)
!     5 = wrong value for date flag (datekey)
!     6 = wrong value for extra variables flag (extvarkey)
!     7 = wrong value for latitude (xlat)
!     8 = inadequate value for gravity wave wavelength (gwlength)
!     9 = wrong value of solar longitude (xdate, if datekey=1)
!    10 = Julian date lies outside [jdate_min:jdate_max] range
!    11 = wrong value of local time (should be in [0:24])
!    12 = Incompatible localtime(.ne.0) and datekey(=0)
!    13 = Unresonable value of 'seedin' (in perturkey=5 case)
!    14 = No dust storm scenario available at such date
!    15 = Could not open a database file (wrong path to database?)
!    16 = Failed loading data from a database file
!    17 = Given (or computed) altitude is underground
!    18 = adding (perturkey=5) perturbation yields unphysical density
!    19 = adding (perturkey=5) perturbation yields unphysical temperature
!    20 = adding (perturkey=5) perturbation yields unphysical pressure
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      implicit none

! -------------------------------------------
!     Additional Option (not in the input) / Obsolete as of version 4.2
!     itimint, flag for seasonal interpolation
!     itimint 0: no seasonal interpolation
!     itimint 1: seasonal interpolation
      integer,parameter :: itimint=1
! -------------------------------------------

      integer,parameter :: nextvar=100                  ! size of extra variable array extvar()
      integer,parameter :: nmeanvar=5                   ! size of meanvar() array
      
!     inputs
!     ******      
      integer,      intent(in)   :: zkey                ! flag for vertical coordinate type
      real   ,      intent(in)   :: xz                  ! vertical coordinate (m or Pa, depending on zkey)
      real   ,      intent(in)   :: xlon                ! east longitude (degrees) 
      real   ,      intent(in)   :: xlat                ! latitude (degrees)
      integer,      intent(in)   :: hireskey            ! flag: high resolution if =1
      integer,      intent(in)   :: datekey             ! flag: 0=earth date 1= Mars date
      real*8 ,      intent(in)   :: xdate               ! earth julian date (or Ls)
      real   ,      intent(in)   :: localtime           ! true solar time at longitude lon, Note: localtime can only be imposed if datekey=1 and should be 0 otherwise
      integer,      intent(in)   :: perturkey           ! flag: perturbation type
      real   ,      intent(in)   :: seedin              ! seed for random number generation, seedin is also used to trigger a reinitialization of perturbation (triggered if value of seedin changes between subsequent calls to CALL_MCD)
      real   ,      intent(in)   :: gwlength            ! gravity wave perturbation (vertical wavelength of)
      integer,      intent(in)   :: scena               ! dust scenario
      integer,      intent(in)   :: extvarkeys(nextvar) ! flag: compute extra variable i if i==1
      character*(*),intent(in)   :: dset                ! path to datafiles

!     outputs
!     *******      
      real,         intent(out)  :: meanvar(nmeanvar)   ! array for mean values
      real,         intent(out)  :: extvar(nextvar)     ! array for extra outputs
      real,         intent(out)  :: seedout             ! current value of 'seed' (used by ran1)
      real,         intent(out)  :: pres                ! atmospheric pressure (Pa)
      real,         intent(out)  :: dens                ! atmospheric density (kg.m-3)
      real,         intent(out)  :: temp                ! atmospheric temperature (K)
      real,         intent(out)  :: zonwind             ! zonal (eastward) wind (m.s-1)
      real,         intent(out)  :: merwind             ! meridional (northward) wind (m.s-1)
      integer,      intent(out)  :: ier                 ! status (error) code

!     local variables
!     *************** 

!     NETCDF file IDs :
      integer,save :: unet                              ! orographic data
      integer,save :: unetm                             ! mean fields   
      integer,save :: unetsd                            ! std dev and rms fields
      integer,save :: unetm_up                          ! mean up fields (thermosphere)
      integer,save :: unetsd_up                         ! std dev up and rms fields (thermosphere)
      integer,save :: ueof                              ! eof fields
      integer,save :: unetm2                            ! season2 for seasonal interpolation- mean field
      integer,save :: unetsd2                           ! season2 for seasonal interpolation- std dev fields
      integer,save :: unetm2_up                         ! season2 for seasonal interpolation- mean fields - up 
      integer,save :: unetsd2_up                        ! season2 for seasonal interpolation- std dev fields - up

      integer,save :: seed                              !     seed (and also current index) for random number generator

      integer dust                                      ! dust scenario
      integer xdust                                     ! for a second scenario (year-to-year interp.) 

!     real, parameter :: R= 191.2                       ! not used any more, see Rnew
      real  Rnew
      real  R_gcm(dimlevs)                              ! R at GCM levels
      real  rho_gcm(dimlevs)                            ! rho at GCM levels
      real  temp_gcm(dimlevs)                           ! temperature at GCM levels
      real  nbsig                                       ! number of standard deviations to add
                              
      !   Julian dates that should bracket "xdate" (if given as a Juilan date)
      real*8,parameter :: jdate_min=2378496.5 ! 01-01-1800 00:00
      real*8,parameter :: jdate_max=2524593.5 ! 01-01-2200 00:00
      
  
      integer       i,l                                 ! for loops
      integer       ierr                                ! to store return codes from called routines
      integer       levlow                              ! database level, lower bound (wrt sought alt.)
      integer       levhi                               ! database level, upper bound (wrt sought alt.)
      real          areoid                              ! distance to center of Mars of reference areoid
      real          areoid_gcm                          ! GCM areoid (m)
      real          areoid_hr                           ! High resolution areoid (m)
      real          height                              ! height above areoid (m) 
      real          oroheight                           ! orographic height (m)
      real          oro_hr                              ! MOLA orographic height (m)
      real          oro_gcm                             ! GCM orographic height (m)
      real          absheight                           ! height above surface (m)
      real          ls                                  ! Solar longitude (deg.)
      real          marsau                              ! Sun-Mars distance (in AU)
      real          modelday                            ! GCM day [0:668.6]
      real          solzenang                           ! solar zenith angle (deg)
      real          loctime                             ! true solar time at longitude lon
      real          utime                               ! universal time (0. to 24. hrs) =local true solar time at lon=0
      real          lmeantime                           ! local meant solar time (01 to 24. hrs) at lon
      real          lon                                 ! longitude east [-180  180]
      real          lat                                 ! latitude (degrees)
      real          ps                                  ! surface pressure
      real          ps_gcm                              ! surface pressure (as read from MCD)
      real          ps_hr                               ! surface pressure (high res, using MOLA topo.)
      real          ps_psgcm                            ! high res to GCM surface pressure ratio
      real          p_pgcm(dimlevs)                     ! high res over GCM pressure ratios

!     variables  (trailing l indicates lower level variable from database)
      real          t,tl                                ! atmospheric temperature
      real          p,pl                                ! atmospheric pressure
      real          rho,rhol                            ! density
      real          u,ul,v,vl,w_l                       ! zonal, meridional and vertical winds
      real          col_h2ovapor,col_h2oice             ! species column (kg/m2)
      real          col_co2,col_co
      real          col_o,col_o2,col_o3
      real          col_h,col_h2
!      real          col_h2o2
      real          col_n2,col_ar
      real          col_elec, col_he
      real          vmr_h2oice,vmr_h2o                  ! volume mixing ration for species (mol/mol)
      real          vmr_co2,vmr_co
      real          vmr_o,vmr_o2,vmr_o3
      real          vmr_h,vmr_h2
!      real          vmr_h2o2
      real          vmr_n2,vmr_ar,vmr_elec,vmr_he
      real          pertm,pertr,pertrho,pertrhogw       ! perturbations
!      real          pertrhoeof
!      data          pertrhoeof /0.0/
      real          pertps
      real          pertu, pertv, pertt
      real          levweight(2)                        ! weights for vertical interpolation
      real          pratio                              ! 'correction' parameter (usually = 1.0, unless
                                                        ! outside of sigma range; it then accounts for
                                                        ! being above/below lowest/highest sigma level)
      real          lamda                               !gravity wave vertical wavelength (m) 
!      real          rdnos(dimnevecs)                   ! deviates for EOF perturbations
!      save          rdnos
      real, save :: rdeof                               ! uniform random number in [0,1] for EOF perturb.
      real, save :: dev                                 ! (random) phase angle for gravity waves
      real, save :: rangw1,rangw2                       !random number for gravity wave spread
      real          pscaleheight                        ! scale height
      real          tsurf,tsurfmax,tsurfmin             ! surface temperatures (K)
      real          potential_temp                      ! potential temperature (K) (reference pressure=610Pa)
      real          rmstsurf                            ! RMS of surface temperature
      real          rmsps                               ! RMS of surface pressure
      real          co2ice                              ! CO2 ice at the surface
      real          dod, rmsdod,dust_mmr                ! tsddod
      real          tauref                              ! daily dust opacity from scenarios
      real          dust_reff                           ! dust effective radius
      real          dust_dep                            ! dust deposition on flat surface kg/m2/s
      real          dust_reff_surf                      ! dust effective radius in first layer m
      real          qext                                ! single scattering extinction dust coefficient
      real          mcoldust                            ! Dust column mass (kg/m2)
      real          rho_dust                            ! Dust density (kg/m3)
      real          mmr_dust                            ! mass mixing ratio dust column (kg/kg) 
      real          profile_reff(dimlevs)               ! dust effective radius profile
      real          profile_mmr(dimlevs)                ! dust mass mlixing ratio profile
      real          surf_h2o_ice                        ! surface H2O (seasonal deposit) (kg/m2)
      real          h2oice_reff                         ! water ice effective radius (m)
!      real          tauh2oice                          ! water ice cloud opacity (abs. at 825 cm-1)
      real          Cp, gamma, viscosity,Rgas           ! Air properties
      real          fluxtop_dn_sw                       ! Incident solar flux at top of the atmosphere (W/m2)
      real          fluxtop_dn_sw_inst                  ! Instantenuous incident solar flux at top of the atmosphere (W/m2)      
      real          fluxtop_up_sw                       ! solar flux reflected to space (W/m2)
      real          fluxsurf_dn_sw                      ! Incident solar flux on horizontal surface (W/m2)
      real          fluxsurf_dir_dn_sw                  ! Direct incoming solar flux on horizontal surface (W/m2)      
      real          fluxsurf_dn_sw_hr                   ! Incident solar flux on local slope (W/m2) (if hireskey=1)      
      real          fluxsurf_up_sw                      ! Reflected solar flux on horizontal surface (W/m2)
      real          rescale_flux                        ! fluxtop_dn_sw_inst/fluxtop_dn_sw
      real          fluxtop_lw                          ! thermal IR flux to space (W/m2)
      real          fluxsurf_lw                         ! thermal IR flux on surface (W/m2)
      real          rmst, rmsu, rmsv, rmsw              ! rms temperature and winds
      real          rmsrho                              ! rms of density at a given pressure level
      real          altrmsp                             ! altitude-wise rms of atmospheric pressure
      real          tmeanl(nmeanvar)                    ! to temporarily store meanvar()
      real          zradius                             ! distance to center of planet
      real          zareoid                             ! height above areoid
      real          zsurface                            ! height above surface
      real          zpressure                           ! atmospheric pressure
      real          zmradius                            ! altitude above mean Mars radius (3.390E6 m)
      real          sheight(dimlevs)                    ! altitudes (above surface) of GCM sigma levels
      real          surfstress                          ! surface stress
      real          sensib_flux                         ! sensible heat flux
      real          vvv                                 ! vertical velocity variance in PBL
      real          vhf                                 ! vertical eddy heat flux in PBL
      real          wstar                               ! free convection velocity
      real          zmax                                ! PBL height


      character*18  name
      character*4   typevar
      character*255 dataset
      integer       lendataset
      character*255 dataset2
      
!  season numbers
      integer       nums,nums2                          ! encompassing 'lower' and 'higher' month #     
      integer,save :: numsprec,nums2prec                ! previous values of nums & nums2
      integer,save :: numsprec_sd,numsprec_gw
      
!  seasonal interpolation weights 
      real          wl,wh
      
!  previous dust scenario
      integer,save :: dustprec 
      
!  previous wavelength of gravity wave perturbation
      real,save :: prevgwlength
      
! previous value of seedin
      real,save :: prevseedin
      
! Large scale EOF perturbed fields
      real          ps_gcm_pert                         ! perturbed GCM surface pressure
      real          ps_hr_pert                          ! perturbed high res surface pressure
      real          temp_gcm_pert(dimlevs)              ! perturbed temperature profile
      
! Near-surface noise (on Ps, Ts and atmospheric temperatures)

      real,save :: ps_noise                             ! 'noise' to add to surface pressure
      real,save :: temp_noise                           ! 'noise' to add to temperature
      real,save :: temp_gcm_noise(dimlevs)              ! 'noise' to add to temperatures at GCM levels
      real,save :: ps_noise_dev                         ! deviate to generate ps_noise
      real,save :: temp_gcm_noise_dev                   ! deviate to generate temp_noise
      
      
!     function declarations
      !real, external ::       gasdev,ran1,ls2sol
      
!     vertical coordinates

      real,save ::  aps(dimlevs)                        ! hybrid coordinate 
      real,save ::  bps(dimlevs)                        ! hybrid coordinate
      real,save ::  pseudoalt(dimlevs)                  ! pseudo altitude      
      real          sigma(dimlevs)                      ! sigma levels to work with
      real          sigma_gcm(dimlevs)                  ! sigma levels in GCM
      real          sigma_hr(dimlevs)                   ! high resolution sigma levels
      
! flag for first call to call_mcd
      logical,save :: firstcall=.true.
      
! flag to (internally) set EOF coordinates-related interpolation (or not)
      logical,save :: inicoordeof                       ! see eofpb
      
! flag to interally add near-surface noise with perturbations
      logical,parameter :: nearsurfnoise=.true.
      logical              air_prop_flag
      logical              rmsoutput
      
! intermediate variables for large scale (EOF) density perturbation

!      real  lowpress,hipress                          ! pressures at levhi and levlow
!      real  lowdens,hidens                            ! densities at levhi and levlow
!      integer oldlevlow,oldlevhi                      ! 'unperturbed' levlow and levhi values
!      real  oldlevweight2
!      real  newrhol
      real col_gcm(dimlevs)                            ! number of mol. between levels in GCM
      real col_hr(dimlevs)                             ! number of mol. between levels in hires
      real col_hr2gcm                                  ! ratio of columns in hires to GCM
      integer flag_ini_profi                           ! flag of initialization in profi()

! Slopes
    
      real slopes_scale                                ! scale at which solar flux is calculated (km)
      real theta_s, psi_s                              ! Local slope (degrees)

! High resolution slope winds     
                 
      
      real theta_slope, psi_slope                      ! Slope inclination/orientation for slope wind scheme
      
      real upslope_wind                                ! upslope wind component (m/s)
      real crossslope_wind                             ! cross-slope wind component (m/s)
     
      real zonal_slope_wind                            ! zonal slope wind component (m/s)
      real merid_slope_wind                            ! meridional slope wond component (m/s)
      
      
! 0. Initializations
      if (firstcall) then ! only for very first call to CALL_MCD
        ! set dummy previous value of seedin
        if (seedin.eq.0) then
          prevseedin=-1.0
        else
          prevseedin=-seedin
        endif
        ! set dummy previous value of gwlength
        if (gwlength.eq.0) then
          prevgwlength=1.0
        else
          prevgwlength=-gwlength
        endif
        ! set dummy previous values of months
        numsprec=0
        nums2prec=0
        numsprec_sd=0
        numsprec_gw=0
        ! set dummy previous value of dust scenario
        dustprec=0
        ! set firstcall to false
        firstcall=.false.
      endif

      ! initializations for every call to CALL_MCD
      ier=0
      inicoordeof=.true.
      flag_ini_profi = 0 ! No initialization in profi()

!***********************************************************************
!  1. Check (and eventually convert) input arguments
!***********************************************************************

!  1.1 Path to data set
!     find last non-blank character and length of 'dset' srting
      lendataset=len_trim(dset)
      if (lendataset.eq.0) then  !default data set case
         dataset = 'MCD_DATA/'
         dataset2 = 'MCD_DATA/'
         lendataset=len_trim(dataset)
      else  !symbolic link or full path to datasets is given explicitly
         dataset = dset
         dataset2 = dset
      endif

!  1.2 Check value of dust scenario
      dust=scena
      if ((dust.lt.1).or.((dust.gt.8).and.(dust.lt.24)).or.(dust.gt.35)) then
        if (output_messages) then
         write(out,*)'CALL_MCD Error: ',scena,' unknown scenario'
        endif
        ier=2
        goto 9999
      endif

!  1.3 Check vertical coordinate type (and set high_res_topo flag)
      if ((zkey.gt.5).or.(zkey.le.0)) then
        if (output_messages) then
          write(out,*)'CALL_MCD Error: zkey=',zkey,' unknown vert. coord'
        endif
        ier=1
        goto 9999
      endif


! 1.4 Check various flags
! 'hireskey' flag:
      if ((hireskey.lt.0).or.(hireskey.gt.1)) then
        if (output_messages) then
          write(out,*)'CALL_MCD Error: wrong value for ','parameter hireskey'
          write(out,*)'               hireskey=',hireskey
        endif
        ier=4
        goto 9999
      endif

! 'datekey' flag:
      if ((datekey.lt.0).or.(datekey.gt.1)) then
        if (output_messages) then
          write(out,*)'CALL_MCD Error: wrong value for ','parameter datekey'
          write(out,*)'               datekey=',datekey
        endif
        ier=5
        goto 9999
      endif

! 'perturkey' flag:
      if ((perturkey.lt.0).or.(perturkey.gt.5)) then
        if (output_messages) then
         write(out,*)'CALL_MCD Error: wrong value for ','parameter perturkey'
         write(out,*)'               perturkey=',perturkey
        endif
        ier=3
        goto 9999
      endif

! 'extvarkeys' flag:
      do i=1,nextvar
      if ((extvarkeys(i).lt.0).or.(extvarkeys(i).gt.1)) then
       if (output_messages) then
        write(out,*)'CALL_MCD Error: wrong value for ','parameter extvarkeys(',i,')'
        write(out,*)'          extvarkeys(',i,')=',extvarkeys(i)
       endif
       ier=6
       goto 9999
      endif
      enddo

! check that the value of gwlength is resonable
      if (((gwlength.lt.2.E3).and.(gwlength.ne.0.)).or.(gwlength.gt.30.E3)) then
        if (output_messages) then
         write(out,*)'CALL_MCD Error: wrong value for ','parameter gwlength'
         write(out,*)'               gwlength=',gwlength
         write(out,*)'(should be in [2000:30000] range)'
        endif
        ier=8
        goto 9999
      endif

! check that the value of 'seedin' is reasonable (in perturkey=5 case only)
      if ((perturkey.eq.5).and.(abs(seedin).gt.4.0)) then
       if (output_messages) then
        write(out,*)'CALL_MCD Error: wrong value for parameter seedin'
        write(out,*)'               seedin=',seedin
        write(out,*)'(should not be more/less ','than +/-4 when perturkey=5)'
       endif
       ier=13
       goto 9999
      endif
      
! 1.4 Check and set latitude and longitude
      if (abs(xlat).gt.90.0) then
        if (output_messages) then
         write(out,*)'CALL_MCD Error: wrong value for latitude=',xlat
        endif
        ier=7
        goto 9999
      else
        lat=xlat
      endif
       
      ! we want longitude to be in [-180:180]
      lon=mod(xlon,360.0)
      if (lon.lt.-180.) then ! in case lon in [-360:-180]
        lon=lon+360.
      endif
      if (lon.gt.180.0) then ! in case lon in [180:360]
        lon=lon-360.
      endif

! 1.5 Perturbations

! 1.5.1 (re-)initialize EOF and GW perturbations, if instructed to do so
! Note: since on first call seedin.ne.prevseedin, the random number generator
! will always be seeded, which is good, since even when no perturbations
! are added, some extra variables need random numbers
      if (seedin.ne.prevseedin) then
        ! generate the seed for random number generation
        ! (seed must then be a strictly negative integer)
        seed=-abs(int(seedin))
        if (seed.eq.0) then
          seed=-1
        endif
        ! compute rdnos() for EOFs
!        do i=1,dimnevecs
!          rdnos(i)=gasdev(seed)
!        enddo
        ! compute rdeof for EOFs
        rdeof=ran1(seed)
        ! compute dev for GW
        dev=ran1(seed)
        rangw1=ran1(seed)
        rangw2=ran1(seed)
        ! compute gaussian deviates for near-surface perturbations
        temp_gcm_noise_dev=gasdev(seed)
        ps_noise_dev=gasdev(seed)
        ! store current seed in seedout
        seedout=seed
        ! set prevseedin to seedin and prevgwlength to gwlength
        prevseedin=seedin
        prevgwlength=gwlength
      endif

! 1.5.2 re-initialize only GW perturbations, if instructed to do so
      if ((gwlength.ne.prevgwlength).and.((perturkey.eq.3).or.(perturkey.eq.4))) then
        ! the random number generator necessarily has already been seeded
        ! get a new random phase for the gravity waves
        dev=ran1(seed)
        ! store current value of seed in seedout
        seedout=seed
        ! set prevgwlength to gwlength
        prevgwlength=gwlength
      endif

! 1.5.3 Check and set GW wavelength, if necessary
      if ((perturkey.eq.3).or.(perturkey.eq.4)) then   ! GW perturbations    
!     &     .or.(extvarkey.eq.1)) then ! some extra variables need 'gwlength'
        ! set wavelength 'lamda'
        if (gwlength.eq.0.0) then ! use a default wavelength
          lamda=16.E3
        else
          lamda=gwlength
          ! Note: it was checked that 2000<gwlength<30000 in 1.4
        endif
      endif

! 1.5.4 Check value of 'seedin' for the 'n times standard dev' perturbation
      nbsig=0 ! dummy initialization (to get rid of compiler warnings)
      if (perturkey.eq.5) then
        ! check that -4<seedin<+4 was done in 1.4
        nbsig=seedin
      endif


!***********************************************************************
! 1.6 Read/evaluate Ls and the corresponding season number
!***********************************************************************

! 1.6.1 Solar longitude and local time
      if (datekey.eq.0) then  ! Earth date
!       (ie: "xdate" contains the Earth Julian date) 

        ! check that "xdate" is a date that is not less than jdate_min
        ! and no more than jdate_max
        if ((xdate.lt.jdate_min).or.(xdate.gt.jdate_max)) then
         if (output_messages) then
          write(out,*)'CALL_MCD error: The given Julian date ','xdate=',xdate
          write(out,*)' lies outside of the [jdate_min:jdate_max] ','range!!'
         endif
         ier=10
         goto 9999
        endif
        
        ! check that user did not try to impose a localtime
        if (localtime.ne.0.0) then
         if (output_messages) then
          write(out,*)'CALL_MCD error: If using Julian dates, ','localtime=',localtime,' must be set to zero!'
         endif
         ier=12
         goto 9999
        endif
        
        ! compute values of ls,marsau,modelday corresponding to "xdate"
        call orbit(xdate,ls,marsau,modelday)
!       call mars_ltime with current longitude for correct local time:
!       localtime is a "local true solar time" or "local apparent time"   
!       which is such that the sun is always highest at noon
!      (differs from mean local time...) 
        call mars_ltime(lon,xdate,ls,loctime,lmeantime)

      else    ! Mars date (ie: "xdate" contains the value of Ls)
        ls=real(xdate)
        ! check that the value of ls makes sense
        if ((ls.lt.0.0).or.(ls.gt.360.0)) then
         if (output_messages) then
           write(out,*)'CALL_MCD error: The given value of ls, xdate=',xdate
           write(out,*)' should not lie outside the [0:360] range!!'
         endif
         ier=9
         goto 9999
        endif
        
        ! find the modelday which corresponds to ls
        modelday=ls2sol(ls)
        
        ! get localtime from input arguments
        loctime=localtime
        
        ! check that localtime makes sense
        if ((loctime.lt.0.0).or.(loctime.gt.24.0)) then
         if (output_messages) then
           write(out,*)'CALL_MCD error: local time, localtime=',localtime
           write(out,*)' should not lie outside the [0:24] range!!'
         endif
         ier=11
         goto 9999
        endif
        
      endif ! of if (datekey.eq.0)

! 1.6.2 Compute the season numbers date corresponds to
      if (((dust.eq.4).or.(dust.eq.5).or.(dust.eq.6)).and.(ls.lt.180.)) then
        if (output_messages) then
         write(out,*)'CALL_MCD Error: no dust storm scenario for Ls=',Ls
        endif
        ier=14
        goto 9999
      endif

      if (itimint.eq.0) then ! no seasonal interpolation
         call season(ls,nums)
      else if (itimint.ge.1) then
!        if seasonal interpolation
         call season2(ls,nums,nums2,wl,wh,dust)
         ! nums, nums2, wl and wh are now set
      endif   

!     Compute utime (true solar time at lon=0)
      call mars_ptime(lon,loctime,utime)

!***********************************************************************
! 2. load appropriate datasets from the database
!***********************************************************************

!     if the scenario changes, reset season numbers to reload all needed arrays
      if (dust.ne.dustprec) then
         numsprec=0
         nums2prec=0
         numsprec_sd=0
         numsprec_gw=0
         dustprec=dust
      endif

!     if the season number changes, mean value has to be reloaded
      if ((nums.ne.numsprec).or.(nums2.ne.nums2prec)) then
      ! Note: both nums and nums2 must be checked because for dust storm
      !       scenarios for limit cases (month 7 and 12) nums=nums2
      !       but moving on to month 8 (or 11), only nums2 (or nums)
      !       has changed
       if (output_messages) then
        write(out,*) 'Loading variables for new season'
       endif

!       open appropriate  NETCDF file(s)
!       *****************************              
        xdust = dust
        ! account for interpolation wrt previous MY, if needed
        if((nums.gt.nums2).AND.(24.le.dust).AND.(dust.le.35)) then 
         if((ls.lt.180).AND.(dust.gt.24)) xdust = dust-1   
        endif    

        call opend(unet,unetm,unetsd,unetm_up,unetsd_up,nums,xdust,dataset(1:lendataset),ierr)
        if (ierr.ne.0) then
           ier=ierr ! error code is set in opend
           goto 9999
        endif
        
        if (itimint.ge.1) then
         xdust = dust   
         ! account for interpolation wrt next MY, if needed
         if((nums.gt.nums2).AND.(24.le.dust).AND.(dust.le.35)) then
          if((ls.gt.180).AND.(dust.lt.35)) xdust = dust+1   
         endif
         call opend(unet,unetm2,unetsd2,unetm2_up,unetsd2_up,nums2,xdust,dataset2(1:lendataset),ierr)
        elseif (itimint.eq.0) then   
           call opend(unet,unetm2,unetsd2,unetm2_up,unetsd2_up,nums,dust,dataset2(1:lendataset),ierr)
        endif   
        if (ierr.ne.0) then
           ier=ierr ! error code is set in opend
           goto 9999
        endif

!       at the first call, load hybrid coordinates and orographic data
!       ************************************************************** 
        if (numsprec.eq.0) then ! true for the very first call to "CALL_MCD"
           ! load hybrid coordinates
           typevar='hybr'
           call loadvar_mcd(unetm,unetm_up,unetm2,unetm2_up,typevar,aps,bps,sigma,pseudoalt,ierr)
                ! aps() and bps() (and pseudoalt()) are now set
           ! note that these are 'saved' and need only be read once
           if (ierr.ne.0) then
             ier=ierr ! error value is set in loadvar_mcd
             go to 9999
           endif
           
           ! load orography and areoid (on GCM grid)
           typevar='orog'
           call loadvar_mcd(unet,unet,unet,unet,typevar,aps,bps,sigma,pseudoalt,ierr)
           ! taborog() and tabareo() (which are commons in constants_mcd.inc)
           ! are now set
           if (ierr.ne.0) then
              ier=ierr ! error value is set in loadvar_mcd
              go to 9999
           endif
           
           ! load surface properties (roughness length, bare ground albedo, surface thermal inertia, water cap)
           typevar='surf'
           call loadvar_mcd(unet,unet,unet,unet,typevar,aps,bps,sigma,pseudoalt,ierr)
           ! tabz0(), tabga(), tabti, tabwc (which are commons in constants_mcd.inc)
           ! are now set
           if (ierr.ne.0) then
              ier=ierr ! error value is set in loadvar_mcd
              go to 9999
           endif
                      
        endif ! of if (numsprec.eq.0)

!       load mean variables      
!       *******************
        if (output_messages) then
          write(out,*) 'Loading new mean variable'
        endif
        typevar='mean'
        call loadvar_mcd(unetm,unetm_up,unetm2,unetm2_up,typevar,aps,bps,sigma,pseudoalt,ierr)
        ! var_2d(), var_2d2(), var_3d() and var_3d2() are now set
        if (ierr.ne.0) then
           ier=ierr ! error value is set in loadvar_mcd
           go to 9999
        endif

        ! set numsprec and nums2prec to the current value of nums and nums2
        numsprec=nums
        nums2prec=nums2
        
        flag_ini_profi = 1 ! Force initializations in profi()

      end if !end if ((nums.ne.numsprec).or.(nums2.ne.nums2prec))

!     if large scale perturbations or extra variables are requested, 
!     load data if not yet done    
!     **************************************************************      
!      if ((perturkey.eq.2).or.(perturkey.eq.4).or.(extvarkey.eq.1)) then
      if ((perturkey.eq.2).or.(perturkey.eq.4)) then
         call loadeof(ueof,rdeof,dust,dataset,ierr)
         if (ierr.ne.0) then
            ier=ierr ! error value is set in loadeof
            go to 9999
         endif
      end if

!     if small scale perturbations or extra variables are requested, 
!     load data if not yet done
!     **************************************************************      
!      if (((perturkey.eq.3).or.(perturkey.eq.4).or.(extvarkey.eq.1))
      if (((perturkey.eq.3).or.(perturkey.eq.4)).and.(nums.ne.numsprec_gw)) then
        if (output_messages) then
          write(out,*) 'Loading new grwp variable'
        endif
        typevar='grwp'
        call loadvar_mcd(unet,unet,unet,unet,typevar,aps,bps,sigma,pseudoalt,ierr)
        if (ierr.ne.0) then
           ier=ierr ! error value is set in loadvar_mcd
           go to 9999
        endif
        numsprec_gw=nums
        
        flag_ini_profi = 1 !  Force initializations in profi()

      end if
      
!     if n std dev perturbations or extra variables are requested, 
!     load data if not yet done
!     ************************************************************ 
!      if (((perturkey.eq.5).or.(extvarkey.eq.1))
      if ((extvarkeys(10).eq.1).or.(extvarkeys(18).eq.1).or.(extvarkeys(21).eq.1).or.(extvarkeys(22).eq.1).or. &
          (extvarkeys(23).eq.1).or.(extvarkeys(24).eq.1).or.(extvarkeys(25).eq.1).or.(extvarkeys(27).eq.1).or. &
          (extvarkeys(38).eq.1)) then
        rmsoutput=.true.
      else
        rmsoutput=.false.
      endif
      if (((perturkey.eq.5).or.(rmsoutput)).and.(nums.ne.numsprec_sd)) then
       ! Note: we load both kinds of RMS since (a rare but possible
       !       eventuality) 'zkey' could change from one call to call_mcd
       !       to the next
        ! Pressure-wise RMS
        typevar='rms'
        call loadvar_mcd(unetsd,unetsd_up,unetsd2,unetsd2_up,typevar,aps,bps,sigma,pseudoalt,ierr)
        if (ierr.ne.0) then
           ier=ierr ! error value is set in loadvar_mcd
           go to 9999
        endif
        ! Altitude-wise RMS
        typevar='arms'
        call loadvar_mcd(unetsd,unetsd_up,unetsd2,unetsd2_up,typevar,aps,bps,sigma,pseudoalt,ierr)
        if (ierr.ne.0) then
           ier=ierr ! error value is set in loadvar_mcd
           go to 9999
        endif
        numsprec_sd=nums
      
        flag_ini_profi = 1 !  Force initializations in profi()
      
      end if

! First "dummy" call of profi() from call_mcd().
! Does not produce the profile, does only initialization (if necessary).
      if(flag_ini_profi.eq.1) then
!      name='rho'
       call profi(rho_gcm,lon,lat,utime,name,ierr,itimint,wl,wh,1,0,0)
      endif

!***********************************************************************
!  3.  Retrieve main meteorological variables
!***********************************************************************

!  3.1 Get GCM orography for location lon,lat
      name='orography'
      call var2d(oro_gcm,lon,lat,1.0,name,ierr,itimint,wl,wh,1.0)
      ! oro_gcm is now set to the value of GCM orography at (lon,lat)

      name='areoid'
      call var2d(areoid_gcm,lon,lat,1.0,name,ierr,itimint,wl,wh,1.0)
      ! areoid_gcm is now set to the value of GCM areoid at (lon,lat)
      
      name='z0'
      call var2d(z_0,lon,lat,1.0,name,ierr,itimint,wl,wh,1.0)
      ! z_0 is now set to the value of GCM roughness length at (lon,lat)
      
      if (hireskey.eq.1) then
      ! get high resolution areoid at (lon,lat)
        call molareoid(dataset(1:lendataset),lon,lat,areoid_hr)
      endif
      
!  3.2 Get surface pressure at desired lon,lat and utime
      ! low resolution (ie: GCM) surface pressure
      name='ps'
      call var2d(ps_gcm,lon,lat,utime,name,ierr,itimint,wl,wh,1.0)

      ! high resolution (ie: using MOLA topography) surface pressure
      if (hireskey.eq.1) then
        call pres0(dataset(1:lendataset),dust,lat,lon,ls,utime,ps_gcm,oro_gcm,wl,wh,ps_hr,oro_hr,ierr)
        if (ierr.ne.0) then
          ier=ierr ! error value set in pres0
          goto 9999
        endif
        ! ps_hr and oro_hr are now set
        oroheight=oro_hr
        areoid=areoid_hr
        ps=ps_hr
        ps_psgcm=ps_hr/ps_gcm
      else
        oroheight=oro_gcm
        areoid=areoid_gcm
        ps=ps_gcm
        ps_psgcm=1.
      endif ! of if (hireskey.eq.1)

!  3.3 Build sigma levels
      ! GCM sigma levels
      do l=1,dimlevs
        sigma_gcm(l)=aps(l)/ps_gcm+bps(l)
      enddo

      ! high res sigma levels
      if (hireskey.eq.1) then
        call build_sigma_hr(sigma_gcm,ps_gcm,ps_hr,sigma_hr,p_pgcm)
      endif
      
      ! sigma levels that will be used further on
      if (hireskey.eq.1) then
        do l=1,dimlevs
          sigma(l)=sigma_hr(l)
        enddo
      else
        do l=1,dimlevs
          sigma(l)=sigma_gcm(l)
          p_pgcm(l)=1. ! No high_res, so set p_pgcm(:) to 1
        enddo
      endif
      
!  3.4 Get GCM temperature profile for location lon,lat and time utime
      name='temp'
      call profi(temp_gcm,lon,lat,utime,name,ierr,itimint,wl,wh,0,0,0)

!  3.5 Get GCM density profile for location lon,lat and time utime
      name='rho'
      call profi(rho_gcm,lon,lat,utime,name,ierr,itimint,wl,wh,0,0,0)

!  3.6 Compute R profile at location lon,lat and utime
      do i=1,dimlevs
        R_gcm(i)=(aps(i)+bps(i)*ps_gcm)/(rho_gcm(i)*temp_gcm(i))
      enddo

      if (hireskey.eq.1) then
        ! assign col_gcm() and col_hr() arrays
        call colint(aps,bps,oroheight,ps_gcm,ps_hr,R_gcm,temp_gcm,col_gcm,col_hr)
      endif

!  3.7 Find database levels encompassing sought altitude and determine
!      corresponding weights for vertical interpolation
      call getsi(xz,zkey,lon,lat,oroheight,areoid,ps,sigma,utime,dset,levhi,levlow,levweight,pratio,   &
                 ierr,itimint,wl,wh,R_gcm,temp_gcm,zareoid,zradius,zsurface,zpressure,zmradius,sheight)
      ! levhi,levlow,levweight(),pratio are now set
      ! zareoid,zradius,zsurface,zpressure and sheight() are also set
      
      if (ierr.ne.0) then
! Note: Error message and error value are given in getsi
         ier=ierr
        goto 9999
      end if

      height=zareoid              ! height above areoid
      absheight=height-oroheight  ! height above surface
      
!      if underground : stop
      if (absheight.lt.-0.01) then
        if (output_messages) then
          write(out,*)'CALL_MCD Error: underground object '
          write(out,*)'                absheight=',absheight
        endif
        ier=17
        goto 9999
      endif

!  3.8 Compute mean field values (winds,density,temperature,pressure)
!      at chosen location

      name='u'
      call var3d(ul,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
      name='v' 
      call var3d(vl,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
      name='temp'
      call var3d(tl,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
      name='rho'
      call var3d(rhol,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)

!     Mean pressure:
      tmeanl(1)=pratio*ps*(sigma(levlow)+(sigma(levhi)-sigma(levlow))*levweight(2))
      tmeanl(2)=rhol ! mean density
      tmeanl(3)=tl   ! mean temperature
      tmeanl(4)=ul   ! mean zonal wind
      tmeanl(5)=vl   ! mean meridional wind
      
      ! store these mean values for output
      do i=1,nmeanvar
         meanvar(i)=tmeanl(i)
      enddo

!***********************************************************************
! 4. Add perturbations, if required
!***********************************************************************

! 4.1 Add large scale variability, if required
!*********************************************      
      if ((perturkey.eq.2).or.(perturkey.eq.4)) then
      
      ! 4.1.0 Compute and add near-surface perturbations
        if (nearsurfnoise.and.(perturkey.gt.1)) then
          call nearsurfacenoise(ps,ps_noise_dev,ps_noise,temp_gcm_noise_dev,temp_gcm_noise,sheight)

          do l=1,dimlevs
            temp_gcm(l)=temp_gcm(l)+temp_gcm_noise(l)
          enddo
        else
          ps_noise=0
          temp_noise=0
        endif ! of if (nearsurfnoise.and.(perturkey.gt.1))

      ! 4.1.1 Build perturbed surface pressure
         name='ps'
         call eofpb(inicoordeof,scena,pertm,pertr,rdeof,lon,lat,levhi,levlow,levweight,pratio,modelday,name,ierr)
         ps_gcm_pert=ps_gcm+pertr+ps_noise
         ! recompute 'high resolution' surface pressure, if required
         if (hireskey.eq.1) then
           call pres0(dataset(1:lendataset),dust,lat,lon,ls,utime,ps_gcm_pert,oro_gcm,wl,wh,ps_hr_pert,oro_hr,ierr)
           if (ierr.ne.0) then
             ier=ierr ! error value set in pres0
             goto 9999
           endif
           ps=ps_hr_pert
           ps_psgcm=ps_hr_pert/ps_gcm_pert
         else
           ps=ps_gcm_pert
           ps_psgcm=1.
         endif ! if (hireskey.eq.1)

      ! 4.1.2 Build corresponding perturbed sigma levels
         ! perturbed GCM sigma levels
         do l=1,dimlevs
           sigma_gcm(l)=aps(l)/ps_gcm_pert+bps(l)
         enddo
         ! perturbed high res. sigma levels
         if (hireskey.eq.1) then
           call build_sigma_hr(sigma_gcm,ps_gcm_pert,ps_hr_pert,sigma_hr,p_pgcm)
         endif         
         ! sigma levels which will be used further on
         if (hireskey.eq.1) then
           do l=1,dimlevs
             sigma(l)=sigma_hr(l)
           enddo
         else
           do l=1,dimlevs
             sigma(l)=sigma_gcm(l)
             p_pgcm(l)=1  ! no high res, p_pgcm(:)=1
           enddo
         endif
         
      ! 4.1.3 Build perturbed temperature profile
         name='temp'
         ! NB: imposed perturbed temperatures on the profile up to
         !     levhi+2 (since what happens above won't matter when
         !     integrating the hydrostatic equation in getsi)
         call profi_eof(inicoordeof,scena,temp_gcm,rdeof,lon,lat,modelday,levhi+2,name,temp_gcm_pert,ierr)

         ! store 'unperturbed' values of levlow and levhi
!         oldlevlow=levlow
!         oldlevhi=levhi
!         oldlevweight2=levweight(2)

      ! 4.1.4 Compute new 'levhi,levlow,levweight,pratio'
         call getsi(xz,zkey,lon,lat,oroheight,areoid,ps,sigma,utime,dset,levhi,levlow,levweight,pratio, &
         ierr,itimint,wl,wh,R_gcm,temp_gcm_pert,zareoid,zradius,zsurface,zpressure,zmradius,sheight)
      ! levhi,levlow,levweight(),pratio are now set
      ! zareoid,zradius,zsurface,zpressure and sheight are also set
         if (ierr.ne.0) then
! Note: Error message and error value are given in getsi
           ier=ierr
           goto 9999
         endif

         height=zareoid              ! height above areoid
         absheight=height-oroheight  ! height above surface

!      if underground : stop
         if (absheight.lt.-0.01) then
           if (output_messages) then
             write(out,*)'CALL_MCD Error: underground object '
             write(out,*)'                absheight=',absheight
           endif
           ier=17
           goto 9999
         endif

      ! 4.1.5 Get new mean values and add EOF perturbations
         name='u'
!         call var3d(ul,lon,lat,zsurface,levhi,levlow,levweight,pratio,
!     &              sheight,p_pgcm,sigma,ps_psgcm,utime,name,ierr,
!     &              itimint,wl,wh)
         if (zsurface.ge.z_0) then
         ! if above aerodynamic roughness length, compute and add perturbation
           call eofpb(inicoordeof,scena,pertm,pertr,rdeof,lon,lat,levhi,levlow,levweight,pratio,modelday,name,ierr)
           if (ierr.ne.0) then
             ier=ierr
             goto 9999
           endif
           ul=ul+pertr
!         else ! below aerodynamic roughness length, no perturbation
         endif

         name='v'
!         call var3d(vl,lon,lat,zsurface,levhi,levlow,levweight,pratio,
!     &              sheight,p_pgcm,sigma,ps_psgcm,utime,name,ierr,
!     &              itimint,wl,wh)
         if (zsurface.ge.z_0) then
         ! if above aerodynamic roughness length, compute and add perturbation
           call eofpb(inicoordeof,scena,pertm,pertr,rdeof,lon,lat,levhi,levlow,levweight,pratio,modelday,name,ierr)
           if (ierr.ne.0) then
             ier=ierr
             goto 9999
           endif
           vl=vl+pertr
!         else ! below aerodynamic roughness length, no perturbation
         endif
         
         name='temp'
!         call var3d(tl,lon,lat,zsurface,levhi,levlow,levweight,pratio,
!     &              sheight,p_pgcm,sigma,ps_psgcm,utime,name,ierr,
!     &              itimint,wl,wh)
         call eofpb(inicoordeof,scena,pertm,pertr,rdeof,lon,lat,levhi,levlow,levweight,pratio,modelday,name,ierr)
         if (ierr.ne.0) then
           ier=ierr
           goto 9999
         endif
         if (nearsurfnoise) then
           temp_noise=temp_gcm_noise(levlow)+(temp_gcm_noise(levhi)-temp_gcm_noise(levlow))*levweight(1)
         else
           temp_noise=0.0
         endif
         tl=tl+pertr+temp_noise

! straightforward (model 0) version:
!        get density as 'mean field' from perturbed state
!         name='rho'
!         call var3d(rhol,lon,lat,zsurface,levhi,levlow,levweight,pratio,
!     &              sheight,p_pgcm,ps_psgcm,utime,name,ierr,
!     &              itimint,wl,wh)
          ! deviation to mean density is thus:
!          pertrhoeof=rhol-meanvar(2)

! new version: (model 1) compute density from other variables
          ! first compute value of R using linear interpolation
!!          rhol=R_gcm(levlow)+(R_gcm(levhi)-R_gcm(levlow))*levweight(1)
          ! use unperturbed value of R=P/(rho*T)
          rhol=tmeanl(1)/(tmeanl(2)*tmeanl(3))
          ! density is then:
          rhol=zpressure/(rhol*tl)
          ! test: use lower value of R
!          rhol=zpressure/(R_gcm(levlow)*tl)
          ! test: use old value of pressure
!          rhol=tmeanl(1)/(rhol*tl)
!           rhol=tmeanl(1)/(rhol*tmeanl(3))
          ! deviation to mean density is thus:
!          pertrhoeof=rhol-meanvar(2)
! Note: computing R using linear interpolation yields 'arcs' in reconstructed
!       density deviation (wrt mean value) vertical profiles
!       Using the value of R corresponding to unperturbed P,T,rho yields
!       occasionnal 'kicks' (due to vertical interval 'mismatches' between
!       perturbed & unperturbed profiles) in density deviations.

! other new version: (model 2)
!   compute rho at levlow and levhi and then interpolate
!   but using 'old' mean level indexes & weights (otherwise there are
!   'kicks' in density deviation (wrt mean value) vertical
!   profiles when oldlevlow /= levlow and oldlevhi /= levhi).
          ! first compute pressures of encompassing levels:
!          lowpress=ps*sigma(oldlevlow)*pratio
!          hipress=ps*sigma(oldlevhi)*pratio
          ! now compute corresponding densities:
!          lowdens=lowpress/(R_gcm(oldlevlow)*temp_gcm_pert(oldlevlow))
!          hidens=hipress/(R_gcm(oldlevhi)*temp_gcm_pert(oldlevhi))
          ! interpolate density using lowdens and hidens
!          rhol=lowdens*p_pgcm(oldlevlow)+oldlevweight2*
!     &         (hidens*p_pgcm(oldlevhi)-lowdens*p_pgcm(oldlevlow))
!          rhol=rhol*pratio ! correction for densities out of sigma range

          ! deviation to mean density is thus:
!          pertrhoeof=rhol-meanvar(2)

!      else if(extvarkey.eq.1) then
      ! just compute for density as an extra variable
!        name='rho'
!        call eofpb(scena,pertm,pertrhoeof,rdeof,lon,lat,
!     &             levhi,levlow,levweight,pratio,modelday,name,ierr)
!        pertrhoeof=0.0
      endif ! if ((perturkey.eq.2).or.(perturkey.eq.4)) 

! 4.2 Add small scale (gravity wave) variability, if required
!************************************************************      
      if ((perturkey.eq.3).or.(perturkey.eq.4)) then
         name='u'
         absheight=height-oroheight
         call grwpb(dset,pertu,rangw1,rangw2,dev,lamda,lon,lat,absheight,tmeanl(2),tmeanl(4),tmeanl(5),  &
                    ps,sigma,utime,name,ierr,itimint,wl,wh,R_gcm,temp_gcm,sheight,p_pgcm,ps_psgcm)
         name='v'
         call grwpb(dset,pertv,rangw1,rangw2,dev,lamda,lon,lat,absheight,tmeanl(2),tmeanl(4),tmeanl(5),  &
                    ps,sigma,utime,name,ierr,itimint,wl,wh,R_gcm,temp_gcm,sheight,p_pgcm,ps_psgcm)
         name='temp'
         call grwpb(dset,pertt,rangw1,rangw2,dev,lamda,lon,lat,absheight,tmeanl(2),tmeanl(4),tmeanl(5),  &
                    ps,sigma,utime,name,ierr,itimint,wl,wh,R_gcm,temp_gcm,sheight,p_pgcm,ps_psgcm)
         name='rho'
         call grwpb(dset,pertrho,rangw1,rangw2,dev,lamda,lon,lat,absheight,tmeanl(2),tmeanl(4),tmeanl(5), &
                    ps,sigma,utime,name,ierr,itimint,wl,wh,R_gcm,temp_gcm,sheight,p_pgcm,ps_psgcm)
                    
         pertrhogw = pertrho
         ul = ul + pertu
         vl = vl + pertv
         tl = tl + pertt
         ! Check that the resulting density is not unphysical
         ! (was reported to happen in rare cases), and thus limit density
         ! to never be less than 5% of what it was before adding pert.
         ! (5% is quite extreme, tests show large decreases most often
         ! do not lead to less than 50% of value)
         rhol=max(rhol+pertrho,0.05*rhol)
      else if(extvarkeys(28).eq.1) then
      ! just compute for density to output as an extra variable
        name='rho'
        if (gwlength.eq.0.0) then ! use a default wavelength
          lamda=16.E3
        else
          lamda=gwlength
          ! Note: it was checked that 2000<gwlength<30000 in 1.4
        endif
        call grwpb(dset,pertrhogw,rangw1,rangw2,dev,lamda,lon,lat,absheight,tmeanl(2),tmeanl(4),tmeanl(5), & 
                   ps,sigma,utime,name,ierr,itimint,wl,wh,R_gcm,temp_gcm,sheight,p_pgcm,ps_psgcm)
      endif

! 4.3 Add n sigmas, if required
!****************************** 
      if (perturkey.eq.5) then
        if (zkey.eq.4) then ! Get pressure-wise RMSs
          name='rmsu'
          call var3d(pertu,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
          name='rmsv'
          call var3d(pertv,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
          name='rmsrho'
          call var3d(pertrho,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
          name='rmstemp'
          call var3d(pertt,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
        else ! get altitude-wise RMSs
          name='armsu'
          call var3d(pertu,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   & 
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
          name='armsv'
          call var3d(pertv,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
          name='armsrho'
          call var3d(pertrho,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
          name='armstemp'
          call var3d(pertt,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                     p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
        endif ! of if (zkey.eq.4)
         name='rmsps'
         call var2d(pertps,lon,lat,1.0,name,ierr,itimint,wl,wh,ps_psgcm)
         
         ul = ul + (nbsig*pertu)
         vl = vl + (nbsig*pertv)
         rhol = rhol + (nbsig*pertrho)
         tl = tl + (nbsig*pertt)
         ps = ps + (nbsig*pertps)
         
         ! check that this has not led to unphysical values
         if (rhol.lt.0.) then
           if (output_messages) then
             write(out,*)'CALL_MCD Error: unphysical density:',rhol
             write(out,*)'  due to addition of ',nbsig,' times the day to day variability'
           endif
           ier=18
           goto 9999
         endif
         if (tl.lt.0.) then
           if (output_messages) then
             write(out,*)'CALL_MCD Error: unphysical temperature:',tl
             write(out,*)'  due to addition of ',nbsig,' times the day to day variability'
           endif
           ier=19
           goto 9999
         endif
         if (ps.lt.0.) then
           if (output_messages) then
             write(out,*)'CALL_MCD Error: unphysical pressure:',ps
             write(out,*)'  due to addition of ',nbsig,' times the day to day variability'
           endif
           ier=20
           goto 9999
         endif
      endif ! of if (perturkey.eq.5)

! 4.4 Store atmospheric fields (pressure, temperature, density, winds)
!     (re-)compute atmospheric pressure
      pl=ps*(sigma(levlow)+(sigma(levhi)-sigma(levlow))*levweight(2))
      pl=pratio*pl

      t=tl      ! temperature
      p=pl      ! pressure
      rho=rhol  ! density
      u=ul      ! zonal wind
      v=vl      ! meridional wind

! 4.5 (re)compute extra variables, if required
!*********************************************   
! Preliminary stuff:
         do i=1,nextvar 
            extvar(i)=0.0
         enddo

! call air_properties under many conditions:
       air_prop_flag=.false.
       if ((extvarkeys(59).eq.1).or.(extvarkeys(60).eq.1).or.(extvarkeys(61).eq.1).or.(extvarkeys(62).eq.1).or. &
           (extvarkeys(17).eq.1).or.(hireskey.eq.1)) then
       
         ! prerequisites to air_properties:
         name='vmr_co2'
         call var3d(vmr_co2,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,  &
                    p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
         name='vmr_n2'
         call var3d(vmr_n2,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                    p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
         name='vmr_ar'
         call var3d(vmr_ar,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
         p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
         name='vmr_o'
         call var3d(vmr_o,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                    p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
         name='vmr_co'
         call var3d(vmr_co,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                    p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
                            
         call air_properties(t,vmr_co2,vmr_n2,vmr_ar,vmr_o,vmr_co,Cp,gamma,viscosity,Rgas)
         air_prop_flag=.true.
         
       endif

         ! the first few extvar() are always computed
         
         
         extvar(1)=zradius      ! Radial distance from planet center (m)
         extvar(2)=zareoid      ! Altitude above areoid (Mars geoid) (m)
         extvar(3)=zsurface     ! Altitude above local surface (m)
         extvar(4)=oroheight    ! orographic height (m) (surface altitude above areoid)
         extvar(5)=oro_gcm      ! GCM orography (m)
         
         ! Local slope inclination and orientation (deg) (if hireskey=1)
         if (hireskey.eq.1) then
          slopes_scale = 2.
          call get_slopes(dataset,lon,lat,slopes_scale,zradius-zsurface,theta_s,psi_s,ier)    
          extvar(6)=theta_s            
          extvar(7)=psi_s
         endif         

         ! Sun-Mars distance (in Astronomical Unit AU)
         if (datekey.eq.0) then ! it has already been computed
           extvar(8)=marsau
         else
           call sunmarsdistance(ls,marsau)
           extvar(8)=marsau
         endif
         
         ! Ls, solar longitude of Mars (deg)
         extvar(9) =ls
         
         !LST: Local true solar time (hrs)
         extvar(10)=loctime

         ! LMT: Local mean time (hrs) at sought longitude (LMT is only computed for Earth date input)
         if (datekey.eq.0) extvar(11)=lmeantime

         ! Universal solar time (LST at lon=0) (hrs)
         extvar(12)=utime
         
         ! Solar zenith angle (deg)
         call solarzenithangle(lat,ls,loctime,solzenang)
         extvar(13)=solzenang
         
         ! Surface temperature (K)
         if (extvarkeys(14).eq.1 .or. hireskey.eq.1) then
           name='tsurf'
           call var2d(tsurf,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(14)=tsurf
         endif
         
         ! Surface pressure (Pa) (high resolution if hireskey=1)        
         if (extvarkeys(15).eq.1) then
           extvar(15) = ps
         endif
         
         ! GCM surface pressure (Pa) 
         if ((perturkey.eq.2).or.(perturkey.eq.4)) then
          extvar(16)= ps_gcm_pert ! ps_gcm is always computed
         else 
          extvar(16)= ps_gcm      ! ps_gcm is always computed
         endif
         
         ! Potential temperature (K) (reference pressure=610Pa)         
         if (extvarkeys(17).eq.1) then
           potential_temp = t*(pref/p)**(rgas/cp)
           extvar(17)=potential_temp
         endif         
                  
         ! Vertical wind component (m/s) >0 when downwards!
         if (extvarkeys(18).eq.1) then
           name='w' 
           call var3d(w_l,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,       &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(18)=w_l
         endif 
         
         ! Zonal slope wind component (m/s)  (if hireskey=1)
         if (hireskey.eq.1) then
       
          call read_slope_map(lon,lat,dataset,theta_slope,psi_slope,ier)
     
          call slope_winds(lat,theta_slope,psi_slope,zsurface,rgas,cp,temp_gcm,ps_hr,sigma,sheight, & 
                           upslope_wind,crossslope_wind,zonal_slope_wind, merid_slope_wind,temp)       
     
          u = u + zonal_slope_wind  
          v = v + merid_slope_wind     
             
          if ((extvarkeys(19).eq.1 .or. extvarkeys(20).eq.1)) then
           extvar(19) =  zonal_slope_wind
           extvar(20) =  merid_slope_wind
          endif
               
         endif  
         
         ! Surface pressure RMS day to day variations (Pa)        
         if (extvarkeys(21).eq.1) then
           name='rmsps'
           call var2d(rmsps,lon,lat,1.0,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(21)=rmsps
         endif 
         
         ! Surface temperature RMS day to day variations (K)         
         if (extvarkeys(22).eq.1) then
           name='rmstsurf'
           call var2d(rmstsurf,lon,lat,1.0,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(22)=rmstsurf
         endif  
         
         ! Atmospheric pressure RMS day to day variations (Pa)    
         if (extvarkeys(23).eq.1) then
           if (zkey.eq.4) then   ! vertical coordinate is pressure
             extvar(23)=0.0
           else
             name='armspressure'
             call var3d(altrmsp,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
             extvar(23)=altrmsp
           endif
         endif
         
         ! Density RMS day to day variations (kg/m^3)      
         if (extvarkeys(24).eq.1) then
           if (zkey.eq.4) then   ! vertical coordinate is pressure
             extvar(24)=0
           else
             name='armsrho'
             call var3d(rmsrho,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
             extvar(24)=rmsrho
           endif
         endif
         
         ! Temperature RMS day to day variations (K)      
         if (extvarkeys(25).eq.1) then
           if (zkey.eq.4) then ! pressure-wise RMS
             name='rmstemp'
             call var3d(rmst,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           else ! altitude-wise RMS
             name='armstemp'
             call var3d(rmst,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           endif
           extvar(25)=rmst
         endif  
         
         ! Zonal wind RMS day to day variations (m/s)
         if (extvarkeys(26).eq.1) then
           if (zkey.eq.4) then ! pressure-wise RMS
             name='rmsu'
             call var3d(rmsu,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    & 
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           else ! altitude-wise RMS
             name='armsu'
             call var3d(rmsu,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           endif
           extvar(26)=rmsu
         endif   
         
         ! Meridional wind RMS day to day variations (m/s)          
         if (extvarkeys(27).eq.1) then
           if (zkey.eq.4) then ! pressure-wise RMS
             name='rmsv'
             call var3d(rmsv,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           else ! altitude-wise RMS
             name='armsv'
             call var3d(rmsv,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           endif
           extvar(27)=rmsv
         endif 
         
         ! Vertical wind RMS day to day variations (m/s)          
         if (extvarkeys(28).eq.1) then
           if (zkey.eq.4) then ! pressure-wise RMS
             name='rmsw'
             call var3d(rmsw,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           else ! altitude-wise RMS
             name='armsw'
             call var3d(rmsw,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                        p_pgcm,sigma,ps_psgcm,1.0,name,ierr,itimint,wl,wh)
           endif
           extvar(28)=rmsw
         endif
         
         ! Compute instantenuous incident solar flux at top of the atmosphere to rescale every solar flux if needed
         if ((extvarkeys(29).eq.1).or.(extvarkeys(30).eq.1).or.(extvarkeys(31).eq.1)    & 
         .or.(extvarkeys(32).eq.1).or.(extvarkeys(33).eq.1)) then 
           
           fluxtop_dn_sw_inst = (solar_const/(marsau**2))*max(0.,cos(solzenang*acos(-1.)/180.))
           
           name='fluxtop_dn_sw'
           call var2d(fluxtop_dn_sw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           
           if(fluxtop_dn_sw.ne.0.) then                      
            rescale_flux = fluxtop_dn_sw_inst/fluxtop_dn_sw
           else 
            rescale_flux = 0.
           endif
                       
         endif
                                        
         ! Incident solar flux at top of the atmosphere (W/m2)                
         if (extvarkeys(29).eq.1) then
           name='fluxtop_dn_sw'
           call var2d(fluxtop_dn_sw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(29)=fluxtop_dn_sw*rescale_flux
         endif        
         
         ! Solar flux reflected to space (W/m2)
         if (extvarkeys(30).eq.1) then
           name='fluxtop_up_sw'
           call var2d(fluxtop_up_sw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(30)=fluxtop_up_sw*rescale_flux
         endif
         
         ! Incident solar flux on horizontal surface (W/m2)
         if (extvarkeys(31).eq.1 .or. extvarkeys(32).eq.1) then
           name='fluxsurf_dn_sw'
           call var2d(fluxsurf_dn_sw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           !if (cos(solzenang*acos(-1.)/180.) .lt. 0.01) fluxsurf_dn_sw = 0.      
           extvar(31)=fluxsurf_dn_sw*rescale_flux
         endif         
         
         ! Incident solar flux on local slope (W/m2) (if hireskey=1)
         if (extvarkeys(32).eq.1 .and. hireskey.eq.1) then
           
           name='tau_pref_gcm'
           call var2d(dod,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           dod=dod*(ps/pref)
           
           name='col_h2oice'
           call var2d(col_h2oice,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)

           name='fluxsurf_dir_dn_sw'
           call var2d(fluxsurf_dir_dn_sw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)             
                    
          call get_irradiance(lon,lat,loctime,ls,fluxsurf_dn_sw*rescale_flux,fluxsurf_dir_dn_sw*rescale_flux, &
          solzenang,dod,col_h2oice,theta_s,psi_s,fluxsurf_dn_sw_hr,ier)                      
 
          extvar(32)=fluxsurf_dn_sw_hr
          
         endif
         
         ! Reflected solar flux on horizontal surface (W/m2)               
         if (extvarkeys(33).eq.1) then
           name='fluxsurf_up_sw'
           call var2d(fluxsurf_up_sw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(33)=fluxsurf_up_sw*rescale_flux
         endif
                 
         ! Thermal IR flux to space (W/m2)         
         if (extvarkeys(34).eq.1) then
           name='fluxtop_lw'
           call var2d(fluxtop_lw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(34)=fluxtop_lw
         endif         
                
         ! Thermal IR flux on surface (W/m2)
         if (extvarkeys(35).eq.1) then
           name='fluxsurf_lw'
           call var2d(fluxsurf_lw,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(35)=fluxsurf_lw
         endif
         
         ! GCM surface roughness length z0 (m)         
         if (extvarkeys(36).eq.1) extvar(36)=z_0
         
         ! GCM surface thermal inertia
         if (extvarkeys(37).eq.1) then
           name='thermal_inertia'
           call var2d(thermal_inertia,lon,lat,1.0,name,ierr,itimint,wl,wh,1.0)
           extvar(37)=thermal_inertia
         endif
         
         ! GCM surface bare ground albedo
         if (extvarkeys(38).eq.1) then
           name='ground_albedo'
           call var2d(ground_albedo,lon,lat,1.0,name,ierr,itimint,wl,wh,1.0)
           extvar(38)=ground_albedo
         endif
         
         ! Monthly mean dust column visible optical depth above surface 
         if (extvarkeys(39).eq.1) then
          if(extvar(32).ne.1 .or. hireskey.ne.1) then  
           name='tau_pref_gcm'
           call var2d(dod,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           dod=dod*(ps/pref)
          endif
          extvar(39)=dod          
         endif 
         
         ! Daily mean dust column visible optical depth above surface
         if (extvarkeys(40).eq.1 .or. extvar(43).eq.1) then
            if(dust.eq.4 .or. dust.eq.5 .or. dust.eq.6) then 
             tauref=5.
            else          
             call read_dust_scenario(dust,lon,lat,modelday,dataset,tauref,ierr)            
             tauref=tauref*(ps/pref)
            endif
            extvar(40) = tauref
         endif
         
         ! Dust mass mixing ratio (kg/kg)                        
         if ((extvarkeys(41).eq.1) .or. (extvarkeys(43).eq.1)) then
           name='dustq'
           call var3d(dust_mmr,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,  &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(41)=dust_mmr
         endif
         
         ! Dust effective radius (m)     
         if ((extvarkeys(42).eq.1)) then
           name="reffdust"
           call var3d(dust_reff,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(42)=dust_reff
         endif
         
         ! Daily mean dust deposition rate on horizontal surface (kg m-2 s-1)
         if (extvarkeys(43).eq.1) then         
           name="reffdust"
           call profi(profile_reff,lon,lat,utime,name,ier,itimint,wl,wh,0,1,1)
           dust_reff_surf = profile_reff(1) ! effective radius of dust near surface (m)
           rho_dust  = 2500.                ! Mars dust density (kg.m-3) 
           qext      = 2.4                  ! dust visible single scattering extinction coeff. (a 0.67um)
           mcoldust = tauref*(4./3.)*rho_dust*dust_reff_surf/qext ! Column dust mass (kg/m2)        
           mmr_dust = mcoldust/(ps/g0)	
           call dust_deposition(ps,temp_gcm(1),rho_gcm(1),mmr_dust,profile_reff(1),dust_dep)
           extvar(43)=dust_dep         
         endif 
         
         ! Monthly mean surface CO2 ice layer (kg/m2)         
         if (extvarkeys(44).eq.1) then
           name='co2ice'
           call var2d(co2ice,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(44)=co2ice
         endif                 
         
         ! Monthly mean surface H2O layer (kg/m2) (non perennial frost)
         if (extvarkeys(45).eq.1) then
           name='h2oice'
           call var2d(surf_h2o_ice,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(45)=surf_h2o_ice
         endif         
         
         ! GCM perennial surface water ice (0 or 1)
         if (extvarkeys(46).eq.1) then
           name='water_cap'
           call var2d(water_cap,lon,lat,1.0,name,ierr,itimint,wl,wh,1.0)
           extvar(46)=water_cap
         endif         
         
         ! Water vapor column (kg/m2)
         if (extvarkeys(47).eq.1) then
           name='col_h2ovapor'
           call var2d(col_h2ovapor,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(47)=col_h2ovapor
           
          if(hireskey.eq.1) then 
           name='vmr_h2ovapor'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(47)=extvar(47)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(47).eq.1) 
         
         ! Water vapor vol. mixing ratio (mol/mol)      
         if (extvarkeys(48).eq.1) then
           name='vmr_h2ovapor'
           call var3d(vmr_h2o,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(48)=vmr_h2o
         endif         
         
         ! Water ice column (kg/m2)
         if (extvarkeys(49).eq.1) then
         
          if(extvar(32).ne.1 .or. hireskey.ne.1) then  
            name='col_h2oice'
            call var2d(col_h2oice,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
          endif
           
          extvar(49)=col_h2oice
          
          if(hireskey.eq.1) then 
           name='vmr_h2oice'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(49)=extvar(49)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(49).eq.1)  
         
         ! Water ice mixing ratio (mol/mol)     
         if (extvarkeys(50).eq.1) then
           name='vmr_h2oice'
           call var3d(vmr_h2oice,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(50)=vmr_h2oice
         endif 
         
         ! Water ice effective radius (m)       
         if (extvarkeys(51).eq.1) then
           name='reffice'
           call var3d(h2oice_reff,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,  &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           ! Corrections to remove extreme unphysical values (due to
           ! undelying averaging and limit with low ice content/high radii)
           if (extvarkeys(50).eq.0) then ! in case vmr_h2oice is not known
             ! get water ice mixing ratio
             name='vmr_h2oice'
             call var3d(vmr_h2oice,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           endif
           if (vmr_h2oice.le.1.e-6) then ! very low ice content
             h2oice_reff=0. ! set radius to zero
           endif
           if (h2oice_reff.ge.1.e-4) then ! unphysically high reff
             h2oice_reff=1.e-4 ! allow it to be at most 100 microns
           endif
           extvar(51)=h2oice_reff
         endif
         
         ! Convective Planetary Boundary Layer (PBL) height (m)
         if ((extvarkeys(52).eq.1).or.(extvarkeys(55).eq.1).or.(extvarkeys(56).eq.1)) then
           name='zmax' 
           call var2d(zmax,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           extvar(52)=zmax
         endif
         
         !  Max. upward convective wind within the PBL (m/s) 
         if (extvarkeys(53).eq.1) then
           name='wstar'
           call var2d(wstar,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! wstar is the convective vertical velocity scale 
           ! multiply it by 2.75 to obtain maximum updraft velocity
           extvar(53)=wstar*2.75
         endif
         
         ! Max. downward convective wind within the PBL (m/s)
         if (extvarkeys(54).eq.1) then
           name='wstar'
           call var2d(wstar,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! wstar is the convective vertical velocity scale 
           ! multiply it by 1.75 to obtain maximum downdraft velocity
           extvar(54)=wstar*1.75
         endif 
         
         ! Convective vertical wind variance at level z (m2/s2)
         if (extvarkeys(55).eq.1) then
           ! This has only a meaning inside the PBL; set it to zero otherwise
           if (zsurface.le.zmax) then
             name='vvv'
             call var3d(vvv,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,     &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           else
             vvv=0.
           endif
           extvar(55)=vvv
         endif 
         
         ! Convective eddy vertical heat flux at level z (m/s/K)         
         if (extvarkeys(56).eq.1) then
           ! This has only a meaning inside the PBL; set it to zero otherwise
           if (zsurface.le.zmax) then
             name='vhf'
             call var3d(vhf,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,     &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           else
             vhf=0.
           endif
           extvar(56)=vhf
         endif
         
         ! Surface wind stress (Kg/m/s2)
         if (extvarkeys(57).eq.1) then
           name='surfstress' ! is a 2D var but pbl_parameter is handled in var3d
           ! note that high zsurface values lead to numerical overflows in
           ! pbl_parameters, so we call var3d with zsurface=10.
           call var3d(surfstress,lon,lat,10.,levhi,levlow,levweight,pratio,sheight,     &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(57)=surfstress
         endif
         
         ! Surface sensible heat flux (W/m2) (<0 when flux from surf to atm.)                              
         if (extvarkeys(58).eq.1) then
           name='sensib_flux' ! is a 2D var but pbl_parameter is handled in var3d
           ! note that high zsurface values lead to numerical overflows in
           ! pbl_parameters, so we call var3d with zsurface=10.
           call var3d(sensib_flux,lon,lat,10.,levhi,levlow,levweight,pratio,sheight,    &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(58)=sensib_flux
         endif
         
         ! Air heat capacity Cp (J kg-1 K-1)
         if (extvarkeys(59).eq.1) extvar(59)=Cp
         
         ! gamma=Cp/Cv Ratio of specific heats
         if (extvarkeys(60).eq.1) extvar(60)=gamma
         
         ! R: Molecular gas constant (J K-1 kg-1)
         if (extvarkeys(61).eq.1) extvar(61)=Rgas
         
         ! Air viscosity estimation (N s m-2)
         if (extvarkeys(62).eq.1) extvar(62)=viscosity
         
         ! Atmospheric scale height (m)
         if (extvarkeys(63).eq.1) then
           Rnew=p/(rho*t)
           pscaleheight=Rnew*t/(g0*a0**2/(a0+real(zareoid))**2)
           extvar(63)=pscaleheight
         endif     
         
         
         ! CO2 vol. mixing ratio (mol/mol)
         if (extvarkeys(64).eq.1) then
           if (.not.air_prop_flag) then
             name='vmr_co2'
             call var3d(vmr_co2,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           endif
           extvar(64)=vmr_co2
         endif
         
         ! N2 vol. mixing ratio (mol/mol)
         if (extvarkeys(65).eq.1) then
           if (.not.air_prop_flag) then
             name='vmr_n2'
             call var3d(vmr_n2,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,  &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           endif
           extvar(65)=vmr_n2
         endif
         
         !Ar vol. mixing ratio (mol/mol)
         if (extvarkeys(66).eq.1) then
           if (.not.air_prop_flag) then
             name='vmr_ar'
             call var3d(vmr_ar,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,  &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           endif
           extvar(66)=vmr_ar
         endif
         
         ! CO vol. mixing ratio (mol/mol)
         if (extvarkeys(67).eq.1) then
           if (.not.air_prop_flag) then
             name='vmr_co'
             call var3d(vmr_co,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,  &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           endif
           extvar(67)=vmr_co
         endif
         
         ! O vol. mixing ratio (mol/mol)
         if (extvarkeys(68).eq.1) then
           if (.not.air_prop_flag) then
             name='vmr_o'
             call var3d(vmr_o,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,   &
                        p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           endif
           extvar(68)=vmr_o
         endif
         
         !O2 vol. mixing ratio (mol/mol)
         if (extvarkeys(69).eq.1) then
           name='vmr_o2'
           call var3d(vmr_o2,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(69)=vmr_o2
         endif
                  
         ! O3 ozone vol. mixing ratio (mol/mol)
         if (extvarkeys(70).eq.1) then
           name='vmr_o3'
           call var3d(vmr_o3,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(70)=vmr_o3
         endif
         
         !H vol. mixing ratio (mol/mol)
         if (extvarkeys(71).eq.1) then
           name='vmr_h'
           call var3d(vmr_h,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,     &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(71)=vmr_h
         endif
         
         !H2 vol. mixing ratio (mol/mol)
         if (extvarkeys(72).eq.1) then
           name='vmr_h2'
           call var3d(vmr_h2,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(72)=vmr_h2
         endif
         

         !He vol. mixing ratio (mol/mol)
         if (extvarkeys(73).eq.1) then
           name='vmr_he'
           call var3d(vmr_he,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,    &
                      p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
           extvar(73)=vmr_he
         endif         
         
         ! CO2 column (kg/m2)
         if (extvarkeys(74).eq.1) then
           name="c_co2"
           call var2d(col_co2,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_co2 is given in mol cm-2; convert to kg/m2
           col_co2=col_co2*(44./6.022e22)
           extvar(74)=col_co2

          if(hireskey.eq.1) then 
           name='vmr_co2'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(74)=extvar(74)*col_hr2gcm
          endif

         endif ! of if (extvarkeys(74).eq.1)
         
         ! N2 column (kg/m2)
         if (extvarkeys(75).eq.1) then
           name="c_n2"
           call var2d(col_n2,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_n2 is given in mol cm-2; convert to kg/m2
           col_n2=col_n2*(28./6.022e22)
           extvar(75)=col_n2
         
          if(hireskey.eq.1) then 
           name='vmr_n2'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(75)=extvar(75)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(75).eq.1)
         
         ! Ar column (kg/m2)
         if (extvarkeys(76).eq.1) then
           name="c_ar"
           call var2d(col_ar,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_n2 is given in mol cm-2; convert to kg/m2
           col_ar=col_ar*(40./6.022e22)
           extvar(76)=col_ar
           
          if(hireskey.eq.1) then 
           name='vmr_ar'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(76)=extvar(76)*col_hr2gcm
          endif
           
         endif ! of if (extvarkeys(76).eq.1)
         
         ! CO column (kg/m2)
         if (extvarkeys(77).eq.1) then
           name="c_co"
           call var2d(col_co,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_co is given in mol cm-2; convert to kg/m2
           col_co=col_co*(28./6.022e22)
           extvar(77)=col_co
           
          if(hireskey.eq.1) then 
           name='vmr_co'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(77)=extvar(77)*col_hr2gcm
          endif
           
         endif ! of if (extvarkeys(77).eq.1)
         
         ! O column (kg/m2)
         if (extvarkeys(78).eq.1) then
           name="c_o"
           call var2d(col_o,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_o is given in mol cm-2; convert to kg/m2
           col_o=col_o*(16./6.022e22)
           extvar(78)=col_o
         
          if(hireskey.eq.1) then 
           name='vmr_o'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(78)=extvar(78)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(78).eq.1)
         
         ! O2 column (kg/m2)
         if (extvarkeys(79).eq.1) then
           name="c_o2"
           call var2d(col_o2,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_o2 is given in mol cm-2; convert to kg/m2
           col_o2=col_o2*(32./6.022e22)
           extvar(79)=col_o2
         
          if(hireskey.eq.1) then 
           name='vmr_o2'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,      col_gcm,col_hr) 
           extvar(79)=extvar(79)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(79).eq.1)
         
         ! O3 column (kg/m2)
         if (extvarkeys(80).eq.1) then
           name="c_o3"
           call var2d(col_o3,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_o3 is given in mol cm-2; convert to kg/m2
           col_o3=col_o3*(48./6.022e22)
           extvar(80)=col_o3
           
          if(hireskey.eq.1) then 
           name='vmr_o3'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(80)=extvar(80)*col_hr2gcm
          endif
           
         endif ! of if (extvarkeys(80).eq.1)
         
         ! H column (kg/m2)
         if (extvarkeys(81).eq.1) then
           name="c_h"
           call var2d(col_h,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_h is given in mol cm-2; convert to kg/m2
           col_h=col_h*(1./6.022e22)
           extvar(81)=col_h
         
          if(hireskey.eq.1) then 
           name='vmr_h'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,col_gcm,col_hr) 
           extvar(81)=extvar(81)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(81).eq.1)
         
         ! H2 column (kg/m2)
         if (extvarkeys(82).eq.1) then
           name="c_h2"
           call var2d(col_h2,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_h2 is given in mol cm-2; convert to kg/m2
           col_h2=col_h2*(2./6.022e22)
           extvar(82)=col_h2
         
          if(hireskey.eq.1) then 
           name='vmr_h2'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,      col_gcm,col_hr) 
           extvar(82)=extvar(82)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(82).eq.1)


         ! He column (kg/m2)
         if (extvarkeys(83).eq.1) then
           name="c_he"
           call var2d(col_he,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_he is given in mol cm-2; convert to kg/m2
           col_he=col_he*(4./6.022e22)
           extvar(83)=col_he
         
          if(hireskey.eq.1) then 
           name='vmr_he'           
           call colcor(col_hr2gcm,lon,lat,utime,name,ierr,itimint,wl,wh,      col_gcm,col_hr) 
           extvar(83)=extvar(83)*col_hr2gcm
          endif
         
         endif ! of if (extvarkeys(83).eq.1)
         
         ! Electron number density (particules/cm3)
         if (extvarkeys(84).eq.1) then
           ! Give an electron Volume Mixing Ratio only below 5.e-6 Pa
           ! (above the "chemistry ionosphere", one would needs to model 
           !  the full ionosphere dynamics, which isn't the case here)
           if (p.ge.5.e-6) then
            name='vmr_elec'
            call var3d(vmr_elec,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight, &
                       p_pgcm,sigma,ps_psgcm,utime,name,ierr,itimint,wl,wh)
            ! vmr_elec is in mol/mol , convert to electronic number
            ! density in particules/cm3
            !c_e=vmr_e*P_air[Pa]*6.023e23[part/mol]/(8.314*1e6[Pa*cm3/(mol*K)]*T[K])->part/cm3
            vmr_elec=vmr_elec*6.022e23*pl/(8.314e6*tl)
           else
             vmr_elec=0.
           endif
           extvar(84)=vmr_elec
         endif         
         
         ! Total electonic content (TEC) (particules/m2)
         if (extvarkeys(85).eq.1) then
           name="c_elec"
           call var2d(col_elec,lon,lat,utime,name,ierr,itimint,wl,wh,ps_psgcm)
           ! c_elec is given in mol cm-2; convert to particules/m2
           col_elec=col_elec*((1./1822.89)/(6.022e22*9.109e-31))
           extvar(85)=col_elec
         endif         
              
        
                  
!     copy to output
      pres=p
      dens=rho
      temp=t
      zonwind=u
      merwind=v

      return
      

!     Error handling : all the outputs are set to a missing data value

9999  pres=-999.0
      dens=-999.0
      temp=-999.0
      zonwind=-999.0
      merwind=-999.0
      do i=1,nmeanvar
         meanvar(i)=-999.0
      end do
      do i=1,nextvar
         extvar(i)=-999.0
      enddo

      end ! end of call_mcd
      
      
      
!==========================================================================================================
      SUBROUTINE pbl_parameters(ngrid,nlay,ps,pplay,pz0, zzlay,pu,pv,wstar_in,hfmax,    & 
                                zmax,pts,ph,z_out,n_out,T_out,u_out,ustar,tstar,vhf,vvv)
      
      use MCD_var, only : g0
      
      IMPLICIT NONE
!==========================================================================================================
!
!   Anlysis of the PBL from input temperature, wind field and thermals outputs.
!
!   -------  
!
!   Author: Arnaud Colaitis 09/01/12
!   MCD VERSION from gcm svn revision 662
!   -------
!
!   Arguments:
!   ----------
!
!   inputs:
!   ------
!     ngrid            size of the horizontal grid
!     nlay             size of the vertical grid
!     pz0(ngrid)       surface roughness length
!     zzlay(ngrid,nlay)   height of mid-layers
!     pu(ngrid,nlay)   u component of the wind
!     pv(ngrid,nlay)   v component of the wind
!     wstar_in(ngrid)  free convection velocity in PBL
!     hfmax(ngrid)     maximum vertical turbulent heat flux in thermals
!     zmax(ngrid)      height reached by the thermals (pbl height)
!     pts(ngrid)       surface temperature
!     ph(ngrid,nlay)   potential temperature T*(p/ps)^kappa
!     z_out(n_out)     heights of interpolation
!     n_out            number of points for interpolation
!
!   outputs:
!   ------
!
!     Teta_out(ngrid,n_out)  interpolated teta
!     u_out(ngrid,n_out)     interpolated u
!     ustar(ngrid)     friction velocity
!     tstar(ngrid)     friction temperature
!
!
!=======================================================================
!
!-----------------------------------------------------------------------
!   Declarations:
!   -------------

!   Arguments:
!   ----------

      INTEGER, INTENT(IN) :: ngrid,nlay,n_out
      REAL, INTENT(IN) :: pz0(ngrid),ps(ngrid),pplay(ngrid,nlay)
      REAL, INTENT(IN) :: zzlay(ngrid,nlay)
      REAL, INTENT(IN) :: pu(ngrid,nlay),pv(ngrid,nlay)
      REAL, INTENT(IN) :: wstar_in(ngrid),hfmax(ngrid),zmax(ngrid)
      REAL, INTENT(IN) :: pts(ngrid),ph(ngrid,nlay)
      REAL, INTENT(IN) :: z_out(n_out)

!    Outputs:
!    --------

      REAL, INTENT(OUT) :: T_out(ngrid,n_out),u_out(ngrid,n_out)
      REAL Teta_out(ngrid,n_out)
      REAL, INTENT(OUT) :: ustar(ngrid), tstar(ngrid)

!   Local:
!   ------

      INTEGER ig,k,n
      REAL karman,nu,rcp,pg
      DATA karman,nu,rcp,pg/.41,0.001,0.2567930,g0/
      SAVE karman,nu,rcp,pg

!    Local(2):
!    ---------

      REAL zout
      REAL rib(ngrid)  ! Bulk Richardson number
      REAL fm(ngrid) ! stability function for momentum
      REAL fh(ngrid) ! stability function for heat
      REAL z1z0,z1z0t ! ratios z1/z0 and z1/z0T
          ! phim = 1+betam*zeta   or   (1-bm*zeta)**am
          ! phih = alphah + betah*zeta    or   alphah(1.-bh*zeta)**ah
      REAL betam, betah, alphah, bm, bh, lambda
          ! ah and am are assumed to be -0.25 and -0.5 respectively
      REAL cdn(ngrid),chn(ngrid)  ! neutral momentum and heat drag coefficient
      REAL pz0t        ! initial thermal roughness length. (local)
      REAL ric         ! critical richardson number
      REAL reynolds(ngrid)    ! reynolds number for UBL
      REAL prandtl(ngrid)     ! prandtl number for UBL
      REAL pz0tcomp(ngrid)     ! computed z0t
      REAL ite
      REAL residual!,zcd0,z1
      REAL pcdv(ngrid),pcdh(ngrid)
      REAL zu2(ngrid)                  ! Large-scale wind at first layer
      REAL pbl_teta(ngrid)             ! mixed-layer potential temperature
      INTEGER pbl_height_index(ngrid)  ! index of nearest vertical grid point for zmax
      REAL dteta(ngrid,nlay),x(ngrid)  ! potential temperature gradient and z/zi
      REAL dvhf(ngrid),dvvv(ngrid)     ! dimensionless vertical heat flux and 
                                       ! dimensionless vertical velocity variance
      REAL vhf(ngrid),vvv(ngrid)       ! vertical heat flux and vertical velocity variance
      INTEGER ii(1)
      LOGICAL dummy

!------------------------------------------------------------------------
!------------------------------------------------------------------------
! PART I : RICHARDSON/REYNOLDS/THERMAL_ROUGHNESS/STABILITY_COEFFICIENTS
!------------------------------------------------------------------------
!------------------------------------------------------------------------
      zout=0 ! dummy initialization to get rid of compiler warning
      dummy=.false.
      IF (z_out(1) .le. 0.) THEN
      dummy=.true.
      ENDIF

      DO n=1,n_out

! Initialisation :

      ustar(:)=0.
      tstar(:)=0.
      IF (dummy) THEN
      zout=1.
      ELSE
      zout=z_out(n)
      ENDIF
      reynolds(:)=0.
      pz0t = 0.
      pz0tcomp(:) = 0.1*pz0(:)
      rib(:)=0.
      pcdv(:)=0.
      pcdh(:)=0.

      ! this formulation assumes alphah=1., implying betah=betam
      ! We use Dyer et al. parameters, as they cover a broad range of Richardson numbers :

      bm=16.            !UBL
      bh=16.            !UBL
      alphah=1.
      betam=5.         !SBL
      betah=5.         !SBL
      lambda=(sqrt(bh/bm))/alphah
      ric=betah/(betam**2)
      DO ig=1,ngrid
       ite=0.
       residual=abs(pz0tcomp(ig)-pz0t)

       zu2(ig)=pu(ig,1)*pu(ig,1)+pv(ig,1)*pv(ig,1)+(log(1.+0.7*wstar_in(ig) + 2.3*wstar_in(ig)**2))**2

       DO WHILE((residual .gt. 0.01*pz0(ig)) .and.  (ite .lt. 10.))

         pz0t=pz0tcomp(ig)
         IF (zu2(ig) .ne. 0.) THEN
            ! Richardson number formulation proposed by D.E. England et al. (1995)
          rib(ig) = (pg/pts(ig))*sqrt(zzlay(ig,1)*pz0(ig))*(((log(zzlay(ig,1)/pz0(ig)))**2)/ &
                    (log(zzlay(ig,1)/pz0t)))*(ph(ig,1)-pts(ig))/(zu2(ig))
         ELSE
!            print*,'warning, infinite Richardson at surface'
!            print*,pu(ig,1),pv(ig,1)
            rib(ig) = ric
         ENDIF

         z1z0=zzlay(ig,1)/pz0(ig)
         z1z0t=zzlay(ig,1)/pz0t

         cdn(ig)=karman/log(z1z0)
         cdn(ig)=cdn(ig)*cdn(ig)
         chn(ig)=cdn(ig)*log(z1z0)/log(z1z0t) 

         ! STABLE BOUNDARY LAYER :
         IF (rib(ig) .gt. 0.) THEN
            ! From D.E. England et al. (95)
            prandtl(ig)=1.
            if(rib(ig) .lt. ric) then
               ! Assuming alphah=1. and bh=bm for stable conditions :
               fm(ig)=((ric-rib(ig))/ric)**2
               fh(ig)=((ric-rib(ig))/ric)**2
            else
               ! For Ri>Ric, we consider Ri->Infinity => no turbulent mixing at surface
               fm(ig)=0.
               fh(ig)=0.
            endif
         ! UNSTABLE BOUNDARY LAYER :
         ELSE
            ! From D.E. England et al. (95)
            fm(ig)=sqrt(1.-lambda*bm*rib(ig))
            fh(ig)=(1./alphah)*((1.-lambda*bh*rib(ig))**0.5)*(1.-lambda*bm*rib(ig))**0.25
            prandtl(ig)=alphah*((1.-lambda*bm*rib(ig))**0.25)/((1.-lambda*bh*rib(ig))**0.5)
         ENDIF
 
        reynolds(ig)=karman*sqrt(fm(ig))*sqrt(zu2(ig))*pz0(ig)/(log(z1z0)*nu)
        pz0tcomp(ig)=pz0(ig)*exp(-karman*7.3*(reynolds(ig)**0.25)*(prandtl(ig)**0.5)+5*karman)
        residual = abs(pz0t-pz0tcomp(ig))
        ite = ite+1

       ENDDO  ! of while
       pz0t=0.

! Drag computation:

         pcdv(ig)=cdn(ig)*fm(ig)
         pcdh(ig)=chn(ig)*fh(ig)
       
      ENDDO ! of ngrid

!------------------------------------------------------------------------
!------------------------------------------------------------------------
! PART II : USTAR/TSTAR/U_OUT/TETA_OUT COMPUTATIONS
!------------------------------------------------------------------------
!------------------------------------------------------------------------

! u* theta* computation

      DO ig=1,ngrid
         IF (rib(ig) .ge. ric) THEN
           ustar(ig)=0.
           tstar(ig)=0.
         ELSE
           ustar(ig)=sqrt(pcdv(ig))*sqrt(zu2(ig))
           tstar(ig)=-pcdh(ig)*(pts(ig)-ph(ig,1))/sqrt(pcdv(ig))
         ENDIF
      ENDDO

! Interpolation:

      DO ig=1,ngrid
        IF(zout .lt. pz0tcomp(ig)) THEN
           u_out(ig,n)=0.
           Teta_out(ig,n)=pts(ig)

        ELSE
          IF (rib(ig) .ge. ric) THEN ! ustar=tstar=0  (and fm=fh=0)
           u_out(ig,n)=0
           Teta_out(ig,n)=pts(ig)
          ELSE
           u_out(ig,n)= ustar(ig)*log(zout/pz0(ig))/(karman*sqrt(fm(ig)))

           Teta_out(ig,n)=pts(ig)+(tstar(ig)*sqrt(fm(ig))*log(zout/(pz0tcomp(ig)))/(karman*fh(ig)))
          ENDIF
        ENDIF

        IF (zout .lt. pz0(ig)) THEN
           u_out(ig,n)=0.
        ENDIF 

      ENDDO

! when using convective adjustment without thermals, a vertical potential temperature
! profile is assumed up to the thermal roughness length. Hence, theoretically, theta
! interpolated at any height in the surface layer is theta at the first level.

!      IF ((.not.calltherm).and.(calladj)) THEN
!       Teta_out(:,n)=ph(:,1)
!       u_out(:,n)=(sqrt(cdn(:))*sqrt(pu(:,1)*pu(:,1)+pv(:,1)*pv(:,1))
!     &                                /karman)*log(zout/pz0(:))
!      ENDIF
              T_out(:,n) = Teta_out(:,n)*(exp((zout/zzlay(:,1))*(log(pplay(:,1)/ps))))**rcp

      ENDDO   !of n=1,n_out


!------------------------------------------------------------------------
!------------------------------------------------------------------------
! PART III : WSTAR COMPUTATION
!------------------------------------------------------------------------
!------------------------------------------------------------------------

! Detection of the mixed-layer potential temperature
! ------------

! Nearest index for the pbl height

!      IF (calltherm) THEN

      pbl_height_index(:)=1

      DO k=1,nlay-1
         DO ig=1, ngrid
            IF (abs(zmax(ig)-zzlay(ig,k)) .lt. abs(zmax(ig)-zzlay(ig,pbl_height_index(ig)))) THEN
               pbl_height_index(ig)=k
            ENDIF
         ENDDO
      ENDDO

! Potential temperature gradient

      dteta(:,nlay)=0.
      DO k=1,nlay-1
         DO ig=1, ngrid
         dteta(ig,k) = (ph(ig,k+1)-ph(ig,k))/(zzlay(ig,k+1)-zzlay(ig,k))
         ENDDO
      ENDDO

! Computation of the pbl mixed layer temperature

      DO ig=1, ngrid
         ii=MINLOC(abs(dteta(ig,1:pbl_height_index(ig))))
         pbl_teta(ig) = ph(ig,ii(1))
      ENDDO


!------------------------------------------------------------------------
!------------------------------------------------------------------------
! PART IV : VERTICAL_VELOCITY_VARIANCE/VERTICAL_TURBULENT_FLUX PROFILES
!------------------------------------------------------------------------
!------------------------------------------------------------------------

! We follow Spiga et. al 2010 (QJRMS)
! ------------

      DO ig=1, ngrid
         IF (zmax(ig) .gt. 0.) THEN
            x(ig) = zout/zmax(ig)
         ELSE
            x(ig) = 999.
         ENDIF
      ENDDO

      DO ig=1, ngrid
         ! dimensionless vertical heat flux
         IF (x(ig) .le. 0.3) THEN
            dvhf(ig) = ((-3.85/log(x(ig)))+0.07*log(x(ig)))*exp(-4.61*x(ig))
         ELSEIF (x(ig) .le. 1.) THEN
            dvhf(ig) = -1.52*x(ig) + 1.24
         ELSE
            dvhf(ig) = 0.
         ENDIF
         ! dimensionless vertical velocity variance
         IF (x(ig) .le. 1.) THEN
            dvvv(ig) = 2.05*(x(ig)**(2./3.))*(1.-0.64*x(ig))**2
         ELSE
            dvvv(ig) = 0.
         ENDIF
      ENDDO

      vhf(:) = dvhf(:)*hfmax(:)
      vvv(:) = dvvv(:)*(wstar_in(:))**2

!      ENDIF ! of if calltherm

      IF (dummy) THEN
      vhf(:)=0.
      vvv(:)=0.
      T_out(:,1)=pts(:)
      u_out(:,1)=0.
      !ustar is computed
      !star is computed
      ENDIF

      RETURN
      END

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine eofpb(inicoord,scena,pertm,pertr,rdeof,lon,lat,levhi,levlow,levweight,pratio,day,name,ier)
      
!     Calculate an EOF perturbation on the 3d variable=name at 
!     longitude=lon, latitude=lat and day=otherday.
!     where otherday=day+(rdeof-0.5)*eof_twindow , with rdeof in [0:1]
!
!     Improved variability model...EOFs calculated in longitude-sigma plane
!
!         Updated feb-2008: added lon-lat-time interpolation of perturbations
!                           + fixed "dust storm case" (where data is only
!                            available over half of the year). E.M.
      use MCD_var, only : deltalateo,deltaloneo,dimnevecs,dimeoday,dimloneo,dimlateo,dimlevs,latmineo,latmaxeo,lonmineo,lonmaxeo,&
                          tabpcsmth,tabpc,tabeou,tabeov,tabeot,tabeops,tabeonormu,tabeonormp,tabeonormv,tabeonormt,              &
                          output_messages,out



      implicit none
      
!     inputs
      logical,   intent(inout) ::  inicoord         ! flag to (re-)set evaluation of lon/lat/time
      
      integer,      intent(in) ::  scena            ! dust scenario (4,5 or 6 == dust storm)
      real,         intent(in) ::  rdeof            ! uniform deviate
      real,         intent(in) ::  lon              ! longitude east of point 
      real,         intent(in) ::  lat              ! latitude of point
      integer,      intent(in) ::  levhi            ! database level upper bound
      integer,      intent(in) ::  levlow           ! database level lower bound
      real,         intent(in) ::  levweight(2)     ! level weight for interpolation / (1) for linear in height (2) for linear in pressure
      real,         intent(in) ::  pratio           ! ratio of pressure to extreme value if out of range
      real,         intent(in) ::  day              ! model day [0:668.6]
      character*18, intent(in) ::  name             ! name of variable
!     real,         intent(in) ::  rdnos(dimnevecs) ! Uniform deviates for a single profile
      
!     outputs
      integer,     intent(out) ::   ier             ! error flag (0=OK, 1=NOK)
      real,        intent(out) ::   pertm           ! perturbation corresponding to trend (not used!!)
      real,        intent(out) ::   pertr           ! perturbation corresponding to random component
      
!     local variables
      logical firstcall              ! flag to signal initializations
      data firstcall/.true./
      save firstcall
      real lat_eof(dimlateo)         ! latitudes, along EOF grid
      real lon_eof(dimloneo)        ! longitudes, along EOF grid
      save lat_eof,lon_eof
      
      integer indlat(2) ! indexes of encompassing latitudes
      data indlat /0,0/ ! dummy initialization to get rid of compiler warning
      integer indlon(2) ! indexes of encompassing longitudes
      data indlon /0,0/ ! dummy initialization to get rid of compiler warning
      integer indtime(2) ! indexes of encompassing dates
      data indtime /0,0/ ! dummy initialization to get rid of compiler warning
      save indlat,indlon,indtime
      
      real rel_lat ! relative position of lat between encompassing latitudes
      data rel_lat /0.0/ ! dummy initialization to get rid of compiler warning
      real rel_lon ! relative position of lon between encompassing longitudes
      data rel_lon /0.0/ ! dummy initialization to get rid of compiler warning
      real rel_time ! relative position of time between encompassing times
      data rel_time /0.0/ ! dummy initialization to get rid of compiler warning
      save rel_lat,rel_lon,rel_time
      
      real marsyear
      parameter (marsyear=668.5921) ! number of sols in a martian year
      ! Time window over which EOF perturbations are picked:
      real eof_twindow ! window size (sols)
      parameter (eof_twindow=30.0)
      
      real otherday  ! model day at which values are sought
      ! values at 4 encompassing nodes and 2 encompassing times
      real values(4,2) !,smthvalues(4,2)
      ! bilinearly interpolated values, at 2 encompassing times
      real val(2) !,smthval(2)
      ! final values, interpolated in time
      real fval !,fsmthval
      
      integer       i,inode,ilon,ilat,itim
      real     norm    ! normalization factor
!      real     average !  average value
!      real     pc(dimnevecs) ! principal components
!      real     pcsmth(dimnevecs) ! smoothed principal components
!      real     pcpert(dimnevecs) ! 'perturbation' principal components
      real     pcpert(dimnevecs,4,2) ! 'perturbation' principal components
      save     pcpert
      real          evecs(dimnevecs)

!      write(out,*) ""
!      write(out,*) "Entering eofpb, name:",name

      ! 1. Initializations
      
      ! first call only initializations
      if (firstcall) then
       ! build latitudes of EOF grid
       ! (NB: dimlateo,latmaxeo,... are known from constants_mcd.inc)
       do i=1,dimlateo
         lat_eof(i)=latmaxeo-(i-1)*deltalateo
       enddo
       ! build longitudes of EOF grid
       do i=1,dimloneo
         lon_eof(i)=lonmineo+(i-1)*deltaloneo
       enddo
        firstcall=.false.
      endif

      ! initialize return code
      ier = 0
      

      ! 2. find indexes of encompassing points
      ! NB: Only need to do this once every call to call_mcd
      if (inicoord) then
      ! 2.1. find encompassing longitudes
       if (lon.ge.lon_eof(dimloneo)) then ! wraparound
        indlon(1)=dimloneo
        indlon(2)=1
        rel_lon=(lon-lon_eof(dimloneo))/deltaloneo
       else
        indlon(1)=1
        do i=1,dimloneo-1
          if ((lon.ge.lon_eof(i)).and.(lon.lt.lon_eof(i+1))) then
            indlon(1)=i
          endif
        enddo
        indlon(2)=indlon(1)+1
        rel_lon=(lon-lon_eof(indlon(1)))/deltaloneo
       endif ! of if (lon.ge.lon_eof(dimloneo))

      ! 2.2 Find encompassing latitudes
       if (lat.ge.lat_eof(1)) then ! beyond northernest latitude
        indlat(1)=1
        indlat(2)=1
        rel_lat=0
       elseif (lat.le.lat_eof(dimlateo)) then ! beyond southernest latitude
        indlat(1)=dimlateo
        indlat(2)=dimlateo
        rel_lat=0
       else ! find encompassing latitudes
        indlat(1)=1
        do i=1,dimlateo-1
          if ((lat.le.lat_eof(i)).and.(lat.gt.lat_eof(i+1))) then
          indlat(1)=i
          endif
        enddo
        indlat(2)=indlat(1)+1
        rel_lat=(lat_eof(indlat(1))-lat)/deltalateo
       endif ! of if (lat.ge.lat_eo(1)) elseif 

      ! 2.3 compute time at which values will be sought
       otherday=mod(marsyear+day+(rdeof-0.5)*eof_twindow,marsyear)
!      otherday=day ! temporary, for tests
!      write(out,*)'eofpb: day=',day,' otherday=',otherday

      ! 2.4 Find encompassing times
       if ((scena.ge.4).and.(scena.le.6)) then
        ! specific to dust storm scenarios (data in Ls 180-360)
        if (otherday.lt.373) then
         ! first day of series; no interpolation
         indtime(1)=1
         indtime(2)=1
         rel_time=0.0
        elseif (otherday.ge.(dimeoday-1)) then
         ! last day of series; no interpolation
         indtime(1)=dimeoday-372
         indtime(2)=dimeoday-372
         rel_time=0.0
        else
         indtime(1)=1
         do i=373,dimeoday-1
          if ((otherday.ge.i).and.(otherday.lt.(i+1))) then
            indtime(1)=i-372 ! because dust storm data starts at month #7
          endif
         enddo
         indtime(2)=indtime(1)+1
         rel_time=(otherday-372.0)-indtime(1)
        endif ! of if (otherday.lt.373) elseif (otherday.ge.(dimeoday-1))
       else ! data is known all year round (MY24,cold & warm scenarios)
        if (otherday.lt.1.0) then ! wraparound
         indtime(1)=dimeoday
         indtime(2)=1
         rel_time=otherday
        elseif (otherday.ge.(dimeoday-1)) then
        ! specific workaround to handle case of
        ! last day of year (which is not of unity length, in the true calendar)
         indtime(1)=dimeoday-1
         indtime(2)=dimeoday
         rel_time=(otherday-int(otherday))*1./0.6 ! so that rel_time in [0:1]
        else
         indtime(1)=1
         do i=1,dimeoday-1
          if ((otherday.ge.i).and.(otherday.lt.(i+1))) then
            indtime(1)=i
          endif
         enddo
         indtime(2)=indtime(1)+1
         rel_time=otherday-indtime(1)
        endif ! of if (otherday.lt.1.0)
       endif ! of if (scena.ge.4).and.(scena.le.6)
      
!        write(out,*) "eofpb: day=",day,' otherday=',otherday
!        write(out,*) "eofpb: indtime(1)=",indtime(1)
!        write(out,*) "eofpb: rel_time=",rel_time

      ! 2.5 Build pcpert(dimnevecs,4,2)
       do itim=1,2
        do inode=1,4
          if (inode.le.2) then ! node # 1 or # 2
            ilat=indlat(1)
          else ! node # 3 or # 4
            ilat=indlat(2)
          endif
          ! read PCs
!          do i=1,dimnevecs
!            pc(i)=tabpc(ilat,indtime(itim),i)
!          enddo
          ! read smoothed PCs
!          do i=1,dimnevecs
!            pcsmth(i)=tabpcsmth(ilat,indtime(itim),i)
!          enddo
          ! build pcpert, 'perturbation' component of principal component
          do i=1,dimnevecs
            ! Note: we multiply by 1.205 to preserve overall variance
!            pcpert(i,inode,itim)=1.205*(pc(i)-pcsmth(i))
            pcpert(i,inode,itim)=1.205*(tabpc(ilat,indtime(itim),i)-tabpcsmth(ilat,indtime(itim),i))
          enddo
        enddo ! of do inode=1,4
       enddo ! of do itim=1,2
      
      endif ! of if (inicoord)


      ! 3. compute values at encompassing nodes and time
      ! values are organized as follows:  v(1,i) v(2,i)
      !                                   v(4,i) v(3,i)

      do itim=1,2 ! loop on encompassing time
        do inode=1,4 ! loop on encompassing nodes
         if (inode.eq.1) then
          ilon=indlon(1)
          ilat=indlat(1)
         elseif (inode.eq.2) then
          ilon=indlon(2)
          ilat=indlat(1)
         elseif (inode.eq.3) then
          ilon=indlon(2)
          ilat=indlat(2)
         else
          ilon=indlon(1)
          ilat=indlat(2)
         endif
!     read normalisation factor, averages and eofs
!     normalisation factor is no longer the standard deviation
!
!     EOF perturbations are stored up to the last model level
         if (levlow.lt.dimlevs) then  ! we are entirely within EOF range
          if (name.eq.'u') then
            norm=tabeonormu(ilat)
            do i=1,dimnevecs
            evecs(i)= tabeou(ilon,ilat,levlow,i)+(tabeou(ilon,ilat,levhi,i)-tabeou(ilon,ilat,levlow,i))*levweight(1)
            enddo
!            average=tabeouave(ilon,ilat,levlow)
!     &             + (tabeouave(ilon,ilat,levhi)-
!     &                tabeouave(ilon,ilat,levlow))*levweight(1)
          elseif (name.eq.'v') then
            norm=tabeonormv(ilat)
            do i=1,dimnevecs
            evecs(i)= tabeov(ilon,ilat,levlow,i)+ (tabeov(ilon,ilat,levhi,i)- tabeov(ilon,ilat,levlow,i))*levweight(1)
            enddo
!            average=tabeovave(ilon,ilat,levlow)
!     &             + (tabeovave(ilon,ilat,levhi)-
!     &                tabeovave(ilon,ilat,levlow))*levweight(1)
          elseif (name.eq.'temp') then
            norm=tabeonormt(ilat)
            if (levweight(1).eq.0.0) then ! happens a lot when
              ! eofpb is called from profi_eof
              do i=1,dimnevecs
                evecs(i)= tabeot(ilon,ilat,levlow,i)
              enddo
            else ! standard case do a vertical interpolation
              do i=1,dimnevecs
                evecs(i)= tabeot(ilon,ilat,levlow,i)+ (tabeot(ilon,ilat,levhi,i)-tabeot(ilon,ilat,levlow,i))*levweight(1)
             enddo
            endif
!            average=tabeotave(ilon,ilat,levlow)
!     &             + (tabeotave(ilon,ilat,levhi)-
!     &                tabeotave(ilon,ilat,levlow))*levweight(1)
!          elseif (name.eq.'rho') then
!            norm=tabeonormr(ilat)
!!        write(out,*)'norm:',norm
!            do i=1,dimnevecs
!            evecs(i)= tabeorho(ilon,ilat,levlow,i)
!     &             +  (tabeorho(ilon,ilat,levhi,i)
!     &             -  tabeorho(ilon,ilat,levlow,i))*levweight(2)
!         write(out,*)'evecs(',i,'):',evecs(i)
!            enddo
          elseif (name.eq.'ps') then
            norm=tabeonormp(ilat)
            do i=1,dimnevecs
               evecs(i)= tabeops(ilon,ilat,i)
            enddo
!            average=tabeopsave(ilon,ilat)
          else
           if (output_messages) then
            write(out,*)'EOFPB Error: ',name,' unknown variable name'
           endif
           ier=1
           goto 9999
          endif
         else  ! we are above the top EOF level, most perturbations constant
          if (name.eq.'u') then
            norm=tabeonormu(ilat)
            do i=1,dimnevecs
              evecs(i)= tabeou(ilon,ilat,dimlevs,i)
            enddo
!            average=tabeouave(ilon,ilat,levlow)
          elseif (name.eq.'v') then
            norm=tabeonormv(ilat)
            do i=1,dimnevecs
              evecs(i)= tabeov(ilon,ilat,dimlevs,i)
            enddo
!            average=tabeovave(ilon,ilat,levlow)
          elseif (name.eq.'temp') then
            norm=tabeonormt(ilat)
            do i=1,dimnevecs
              evecs(i)= tabeot(ilon,ilat,dimlevs,i)
            enddo
!            average=tabeotave(ilon,ilat,levlow)
!          elseif (name.eq.'rho') then
!            norm=tabeonormr(ilat)
!            do i=1,dimnevecs
!              evecs(i)= tabeorho(ilon,ilat,dimlevs,i)
!            enddo
          elseif (name.eq.'ps') then
            norm=tabeonormp(ilat)
            do i=1,dimnevecs
              evecs(i)= tabeops(ilon,ilat,i)
            enddo
!            average=tabeopsave(ilon,ilat)
          else
            if (output_messages) then
             write(out,*)'EOFPB Error: ',name,' unknown variable name'
            endif
            ier=1
            goto 9999
          endif ! of if (name.eq.'u') elseif ...
         endif ! of if (levlow.lt.dimlevs)
!
!     calculate perturbation
!
!          pertm=0.0
!          pertr=0.0
          values(inode,itim)=0.0 ! initialization
!          smthvalues(inode,itim)=0.0 ! initialization
          do i=1,dimnevecs !72 !dimnevecs
!            smthvalues(inode,itim)=smthvalues(inode,itim)+
!     &                         pcsmth(i)*evecs(i)
            ! here values(:,:) is used to store the perturbation
            values(inode,itim)=values(inode,itim)+pcpert(i,inode,itim)*evecs(i)
!            pertm=pertm+pcsmth(i)*evecs(i)
!       write(out,*)'i:',i,' pcvar:',pcvar(i),' rdnos:',rdnos(i),
!     &            ' evecs:',evecs(i)
!            pertr=pertr+pcvar(i)*rdnos(i)*evecs(i)
!            write(out,*)' pertr:',pertr
          enddo
!
!     renormalise and add average
!
!          pertm=pertm*norm
!          pertr=pertr*norm
!          smthvalues(inode,itim)=average+smthvalues(inode,itim)*norm
          values(inode,itim)=values(inode,itim)*norm
          ! values(:,:) now contains the perturbed field
        enddo ! do inode=1,4
        
        ! bilinear interpolation using four neighbours
!        if ((name.eq.'rho').or.(name.eq.'ps')) then
!        if (name.eq.'ps') then
          ! interpolate the log() ! NO, because these are deviations to mean
!          val(itim)=(1.-rel_lon)*(1.-rel_lat)*log(values(1,itim))
!     &              +rel_lon*(1.-rel_lat)*log(values(2,itim))
!     &              +rel_lon*rel_lat*log(values(3,itim))
!     &              +(1.-rel_lon)*rel_lat*log(values(4,itim))
!          val(itim)=exp(val(itim))
!        else ! bilinear interpolation of the variable
          val(itim)=(1.-rel_lon)*(1.-rel_lat)*values(1,itim)+rel_lon*(1.-rel_lat)*values(2,itim) & 
                     +rel_lon*rel_lat*values(3,itim)+(1.-rel_lon)*rel_lat*values(4,itim)
!        endif
      enddo ! do itim=1,2

      ! 4. linear interpolation in time
      fval=(1.0-rel_time)*val(1)+rel_time*val(2)
!      fsmthval=(1.0-rel_time)*smthval(1)+rel_time*smthval(2)

      pertr=fval

!      write(out,*)'eofpb: pertr=',pertr

      ! set inicoord to false, since rel_lat, rel_lon, rel_time ... are
      ! now known (and won't change aduring current call to call_mcd).
      inicoord=.false.

      return

!     error handling
 9999 pertm = 0.0
      pertr = 0.0
      return

      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine profi_eof(inicoord,scena,profile,rdeof,lon,lat,day,toplevpert,name,profile_pert,ier)

!     Add EOF perturbations to all vertical levels of a (known) profile

      use MCD_var, only : dimlevs, out, output_messages

      implicit none

!     Inputs 
      logical,   intent(inout) ::   inicoord              ! flag to (re-)set evaluation of lon/lat/time passed on to eofpb
      
      integer,      intent(in) ::   scena                 ! dust scenario 
      real,         intent(in) ::   profile(dimlevs)      ! the GCM profile at GCM levels
      real,         intent(in) ::   rdeof                 ! uniform deviate, for EOF perturbations
      real,         intent(in) ::   lon                   ! east longitude (degrees)
      real,         intent(in) ::   lat                   ! latitude (degrees)
      real,         intent(in) ::   day                   ! model day, in [0:668.6]
      integer,      intent(in) ::   toplevpert            ! model layer up to which perturbation will be added
      character*18, intent(in) ::   name                  ! name of variable
!     real,         intent(in) ::   rdnos(dimnevecs)      ! uniform deviates
      
!     Outputs
      real,        intent(out) ::   profile_pert(dimlevs) ! perturbed profile at GCM levels
      integer,     intent(out) ::   ier                   ! error flag (=0 if OK)

! local variables
      integer i
      real pertm ! perturbation corresponding to trend (from eofpb)
      real pertr ! perturbation corresponding to random component (from eofpb)
      integer levlo ! local value for call to eofpb
      integer levhi ! local value for call to eofpb
      real levweight(2) ! local value for call to eofpb
      real pratio ! local (unused) value for call to eofpb
      
      integer toppertlev ! level up to which perturbation will be added
      
      if (toplevpert.gt.dimlevs) then
      ! in case input toplevpert is greater than dimlevs
        toppertlev=dimlevs
      else
        toppertlev=toplevpert
      endif
      
      if (name.eq.'temp') then
        ! add perturbation to levels up to toppertlev
        do i=1,toppertlev
         if (i.lt.dimlevs) then ! general case
          levweight(1)=0.0 ! all the weight on levlo
          levlo=i
          levhi=i+1
          ! get EOF perturbation for level levlo
          call eofpb(inicoord,scena,pertm,pertr,rdeof,lon,lat,levhi,levlo,levweight,pratio,day,name,ier)
          ! add EOF perturbation
          profile_pert(levlo)=profile(levlo)+pertr
         else ! special case if last level is also perturbed
          levweight(1)=1.0 ! i.e. all the weight on levhi
          levlo=dimlevs-1
          levhi=dimlevs
          ! get EOF perturbation for level levhi
          call eofpb(inicoord,scena,pertm,pertr,rdeof,lon,lat,levhi,levlo,levweight,pratio,day,name,ier)
          ! add EOF perturbation
          profile_pert(levhi)=profile(levhi)+pertr
         endif ! of if (i.lt.dimlevs)
        enddo
        
        ! levels above toppertlev are not perturbed
        do i=toppertlev+1,dimlevs
          profile_pert(i)=profile(i)
        enddo
      else
        if (output_messages) then
          write(out,*) 'PROFI_EOF Error: unknowm name:',name
        endif
        ier=1
      endif ! of if (name.eq.'temp')
      
      end
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      function gasdev(idum)

!     Return a Gaussian deviate with zero mean and unit standard deviation.
!     Uses function ran1()
!     If idum is negative, then deviates are (re-)initialized.
! Note: When initialized, the function actually computes 2 deviates,
!       'gset' and 'gasdev'. It then returns 'gasdev' and saves 'gset'
!       which will be returned at the next call of the function.
      implicit none

!     inputs
      integer, intent(in) ::  idum    ! Seed for random number generator
                                      ! is altered if calls to function ran1() occur

      real    gasdev

!     local variables
      integer iset    ! flag (triggers the generation of 2 deviates if =0)
      data    iset/0/
      save    iset
      real    v1      ! random number (between -1 and 1)
      real    v2      ! random number (between -1 and 1)
      real    r
      real    fac
      real    gset    ! extra deviate (saved for next call to function)
      save    gset

! called function
      !real, external ::   ran1

      if (idum.lt.0) iset=0  ! Reinitialize deviates generation
      if (iset.eq.0) then ! compute 2 deviates, gasdev and gset
1       v1=2.*ran1(idum)-1.
        v2=2.*ran1(idum)-1.
        r=v1*v1+v2*v2
        if ((r.ge.1.).or.(r.eq.0.)) goto 1
        fac=sqrt(-2.*log(r)/r)
        gset=v1*fac
        gasdev=v2*fac
        iset=1  ! set flag to signal there is an extra deviate at hand
      else   ! return saved deviate 'gset'
        gasdev=gset
        iset=0  ! set flag to signal there is no extra deviate at hand
      endif

      return
      end


!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine getsi(xz,zkey,lon,lat,oroheight,areoid,ps,sigma,utime,dset,    &
                       levhi,levlow,levweight,pratio,ier,itimint,wl,wh,R_gcm,   & 
                       temp_gcm,zareoid,zradius,zsurface,zpressure,zmradius,sheight)

!     Find the nearest datafile levels and vertical interpolation weights at
!     longitude=lon, latitude=lat and vertical position xz (which may be
!     any of 'above areoid' or 'above surface'
!      or 'radius from center of planet' 
!      or 'altitude above mean radius'
!      or 'Pressure' coordinate)
!     Last Updated feb-2008: added 'zmradius' input
!                           +improved Tmean interpolation   E.M. 


      use MCD_var, only : dimlevs, a0, g0, nbvar3d, ma3d, varname3d, out, output_messages

      implicit none
      
!  zkey    :                   switch to choose which z variable
!                               is input and used to find other three :
!           zkey=1  zradius (m)  -> zareoid, zsurface, zpressure, zmradius
!           zkey=2  zareoid (m)  -> zradius, zsurface, zpressure, zmradius
!           zkey=3  zsurface (m) -> zradius, zareoid, zpressure, zmradius
!           zkey=4  zpressure (Pa) -> zradius, zareoid, zsurface, zmradius
!           zkey=5  zmradius (m) -> zradius, zareoid, zsurface, zpressure
!           zkey=-5  case of getsi call by grwpb 

!     inputs
      real,          intent(in) ::  xz                ! altitude (see zkey)
      integer,       intent(in) ::  zkey              ! switch to choose z type (see above)          
      real,          intent(in) ::  lon               ! east longitude
      real,          intent(in) ::  lat               ! latitude
      real,          intent(in) ::  oroheight         ! height of surface above reference areoid (m)
      real,          intent(in) ::  areoid            ! reference areoid (m)
      real,          intent(in) ::  ps                ! surface pressure (Pa)
      real,          intent(in) ::  sigma(dimlevs)    ! sigma levels
      real,          intent(in) ::  utime             ! Universal time (0 to 24 hrs)=local time at lon=0
      character*(*), intent(in) ::  dset              ! Path to Dataset
      integer,       intent(in) ::  itimint           ! seasonal interpolation flag
      real,          intent(in) ::  wl, wh            ! seasonal interpolation weights
      real,          intent(in) ::  R_gcm(dimlevs)    ! R at GCM levels
      real,          intent(in) ::  temp_gcm(dimlevs) ! temperature at GCM levels

!     outputs
      integer,      intent(out) ::  levhi             ! database level upper bound
      integer,      intent(out) ::  levlow            ! database level lower bound
      real ,        intent(out) ::  levweight(2)      ! level weight for interpolation/(1) for linear in height (2) for linear in pressure
      
      
      
      real          pratio         !p/p(top, bottom) for extrapolation,
                                   ! 1 if in range
      integer       ier            !error flag (0=OK, not 0 =NOK)

      real zradius     ! distance to center of planet
      real zareoid     ! height above areoid
      real zsurface    ! height above surface
      real zpressure   ! pressure
      real zmradius    ! altitude above mean radius of planet
      real sheight(dimlevs) ! altitude above surface of sigma levels

!     local variables
      real marsradius ! mean Mars radius (m)
      parameter (marsradius=3.396E6)
      real          height         !height of point above areoid (m)
      real          absheight         !height of point above surface (m)
      integer       l
      real          zsig
      
!     Gravity on mean areoid
!     The areoid is defined as a surface of constant gravitational plus
!     rotational potential. The inertial rotation rate of Mars is assumed
!     to be 0.70882187E-4 rad/s. This potential is the mean value at the
!     equator at a radius of 3396.000 km, namely 12652804.7 m^2/s^2,
!     calculated from Goddard Mars Gravity Model mgm1025
!     [LEMOINEETAL2001] evaluated to degree and order 50.
      real          g
!      real          R 
!      data          R /191.1/
!     R replaced by Rnew  (varies with altitude)
!      real          Rnew(dimlevs)
      real          Tmean          ! "mean" temperature of a layer
      real          Rogct(dimlevs) 
      real          vmr_gcm(dimlevs)  ! vmr at GCM levels
      real          vmr(nbvar3d)
      integer       i,igas,ierr
      real          dz,dz_max,dz_min,xsig,z

      ier=0


!     Calculate altitude above the surface of each model layer: sheight(l)
!     integrate hydrostatic equation
!     Rogct is the R/g variable depending on dimlevs 
      g = g0*(a0/(a0+oroheight))**2
      Rogct(1) = R_gcm(1)/g          !Rnew(1)/g
      Tmean = temp_gcm(1)            !t(1)
      sheight(1)= - Rogct(1)*temp_gcm(1)*log(sigma(1))

      do l=2, dimlevs
        if (temp_gcm(l).ne.temp_gcm(l-1)) then
         Tmean = real((dble(temp_gcm(l)-temp_gcm(l-1))) / dlog(dble(temp_gcm(l))/dble(temp_gcm(l-1))))
         ! NB: double precision must be used here in case
         ! temp_gcm(l) and temp_gcm(l-1) are almost equal  
        else
         Tmean = temp_gcm(l)
        end if
        g = g0*(a0/(a0+oroheight+sheight(l-1)))**2
        Rogct(l) = R_gcm(l)/g
        sheight(l) = sheight(l-1) - Rogct(l)*Tmean*log(sigma(l)/sigma(l-1))
      end do

!ccccccccccccccccccccccccccccccccccccccccccccccc     
!     height calculation      
      if (zkey.eq.1) then ! input xz is distance to center of planet
              zradius=xz
      elseif (zkey.eq.2) then ! input xz is height above areoid
              zareoid=xz
      elseif (zkey.eq.3) then ! input xz is altitude above surface
            zsurface=xz
      elseif (zkey.eq.4) then ! input xz is atmospheric pressure
          zpressure=xz
!         compute zsurface
          if(zpressure.gt.ps) then
            if (output_messages) then
              write(out,*)'GETSI Error: underground object '
            endif
            ier=17
            goto 9999
          end if
          
          zsig = real(zpressure)/ps
          if (zsig.gt. sigma(1)) then
             zsurface= -log(zsig)*R_gcm(1)*temp_gcm(1)/g0
          else if (zsig.lt.sigma(dimlevs) ) then
             g = g0*(a0/(a0+oroheight+sheight(dimlevs)))**2
!             zsurface= sheight(dimlevs)
!     &        -log(zsig/sigma(dimlevs))*R_gcm(dimlevs)
!     &                                 *temp_gcm(dimlevs)/g
             ! Compute zsurface
             do igas=1,nbvar3d
              ! extract the vmr of various gases
              if(ma3d(igas).lt.0) cycle   
              call profi(vmr_gcm,lon,lat,utime,varname3d(igas),ierr,itimint,wl,wh,0,dimlevs,dimlevs)
              vmr(igas) = vmr_gcm(dimlevs)
             enddo 
!
! Search for the altitude corresponding to the given pressure
! by the bisection method
!
             dz_max = 100000.0e+3 ! max possible delta
             dz_min = 0.0   

             do i=0,100 ! max number of iterations
              dz = 0.5*(dz_max+dz_min)
              z  = (a0+oroheight+sheight(dimlevs))*dz/(a0+oroheight+sheight(dimlevs)+dz) ! z=r0*dz/(r0+dz)
              xsig = 0.0

              do igas=1,nbvar3d
               if(ma3d(igas).lt.0) cycle   
               xsig = xsig + vmr(igas)*sigma(dimlevs)*exp(-g*z/(8314.4598/ma3d(igas)*temp_gcm(dimlevs)))               
              enddo

              if(abs(xsig-zsig)/zsig.lt.0.05) goto 5555
              if(xsig.gt.zsig) then 
               dz_min = dz
              else 
               dz_max = dz
              endif 
             enddo !i
   
             ! If the loop repeat to the end this means that 
             ! for a given range and precision the conversion of altitude
             ! has failed. Further the closest altitude is used.
             !    
             if (output_messages) then
              write(out,*)'CALL_MCD Error: conversion of altitude','failed in getsi().'
             endif   
   
 5555        continue    
             zsurface= sheight(dimlevs)+dz
          else
            do  l=1,dimlevs-1
              if ((zsig.ge.sigma(l+1)).and.(zsig.le.sigma(l))) then
                zsurface= sheight(l) + (sheight(l+1) -sheight(l))  * log(zsig/sigma(l)) / log(sigma(l+1)/sigma(l)) 
                exit
              end if
            end do
          end if
      elseif (zkey.eq.5) then ! input xz is altitude above mean Mars radius
        zmradius=xz
      endif      
      
! absheight = zsurface for the first call of getsi       
! absheight = xz for call to getsi from  grwpb      
      if (zkey.eq.-5) then ! call from grwpb
        absheight=xz
      else
        ! compute required zradius,zareoid,zsurface and/or zmradius
        if (zkey.eq.1.) then ! zradius is known
          zareoid=zradius-areoid
          zsurface=zareoid-oroheight
          zmradius=zradius-marsradius
        elseif (zkey.eq.2) then ! zareoid is known
          zradius=zareoid+areoid
          zsurface=zareoid-oroheight
          zmradius=(areoid-marsradius)+zareoid
        elseif ((zkey.eq.3).or.(zkey.eq.4)) then ! zsurface is known
          zareoid=zsurface+oroheight
          zradius=zareoid+areoid
          zmradius=(areoid-marsradius)+zareoid
        elseif (zkey.eq.5) then ! zmradius is known
          zradius=marsradius+zmradius
          zareoid=zmradius-(areoid-marsradius)
          zsurface=zareoid-oroheight
        endif
        
        height=zareoid              ! height above areoid
        absheight=height-oroheight  ! height above surface
      endif

!cccccccccccccccccccccccccccccccccccccccccccccccccc      
      
!     find levhi, levlow and levweight
!     compute g (at height=zareoid)
      g = g0*(a0/(a0+oroheight+absheight))**2
      if (absheight.lt.sheight(1)) then
!       below the lowest layer
        levhi=1
        levlow=1
        levweight(1)=1.
        levweight(2)=0.
        pratio=exp((sheight(1)-absheight)*g/(R_gcm(1)*temp_gcm(1)))
      elseif (absheight.ge.sheight(dimlevs)) then
!       above the top layer
        levhi=dimlevs
        levlow=dimlevs
        levweight(1)=0.
        levweight(2)=1.
!        pratio=exp((sheight(dimlevs)-absheight)*g/(R_gcm(dimlevs)
!     &                                             *temp_gcm(dimlevs)))
! z = (r1/r0)**2*r0*dz/(r0+dz) where r1 is alt where g was calculated 
        z = (a0+oroheight+absheight)**2/(a0+oroheight+sheight(dimlevs))*(absheight-sheight(dimlevs))/(a0+oroheight+absheight)
        pratio = 0.0
        do igas=1,nbvar3d
         ! Pressure is computed assuming hydrostatic for each species
         if(ma3d(igas).lt.0) cycle   
         call profi(vmr_gcm,lon,lat,utime,varname3d(igas),ierr,itimint,wl,wh,0,dimlevs,dimlevs)
         pratio = pratio+vmr_gcm(dimlevs)*exp(-z*g/(8314.4598/ma3d(igas)*temp_gcm(dimlevs)))
        enddo        
      else
!       general case: sheight(1)<=absheight<=sheight(dimlevs)
       do l=1,dimlevs-1
        if ((absheight.ge.sheight(l)).and.(absheight.lt.sheight(l+1))) then
          levhi=l+1
          levlow=l
          levweight(1)=(absheight-sheight(levlow))/(sheight(levhi)-sheight(levlow))
          levweight(2)=(1.-(sigma(levhi)/sigma(levlow))**levweight(1))/(1.-(sigma(levhi)/sigma(levlow)))
          pratio=1.
        endif
       enddo
      endif

!     Compute pressure
      zpressure=ps*(sigma(levlow)+(sigma(levhi)-sigma(levlow))*levweight(2))*pratio

      return

!     Errror handling
 9999 levhi=0
      levlow=0
      levweight(1)=0.
      levweight(2)=0.
      pratio=0.

      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine grid4(lon,lat,dlon,dlat,t,u)

!     Given longitude=lon and latitude=lat find the nearest 4 horizontal
!     gridpoints in the database and bilinear interpolation weights.
!
!     Grid points are arranged as follows:
!              4 3
!              1 2 

      use MCD_var, only : deltalat,deltalon,dimlat,dimlon,latmax,latmin,lonmax,lonmin
      
      implicit none


!     inputs
      real,    intent(in) :: lon      !east longitude of point
      real,    intent(in) :: lat      !latitude of point

!     outputs
      integer, intent(out) :: dlon(4)  !index, along longitudes, of database points
      integer, intent(out) :: dlat(4)  !index, along latitudes, of database points
      real,    intent(out) :: t        !weight (normalized longitudinal distance to point 1)
      real,    intent(out) :: u        !weight (normalized latitudinal distance to point 1)

!     local variables
      real    alon,alat
      integer i

!     wraparound
      if (lon.ge.lonmax) then
         dlon(1)=dimlon
         dlon(2)=1
         dlon(3)=1
         dlon(4)=dimlon
         t=(lon-lonmax)/deltalon
      else
         alon=lonmin
         do i=1,dimlon-1
            if ((lon.ge.alon).and.(lon.lt.alon+deltalon)) then
               dlon(4)=i
               dlon(3)=i+1
               dlon(1)=i
               dlon(2)=i+1
               t=(lon-alon)/deltalon
            endif
            alon=alon+deltalon
         enddo
      endif

      if (lat.le.latmin) then
         dlat(4)=1
         dlat(3)=1
         dlat(1)=1
         dlat(2)=1
         u=0.
      elseif (lat.ge.latmax) then
         dlat(4)=dimlat
         dlat(3)=dimlat
         dlat(1)=dimlat
         dlat(2)=dimlat
         u=0.
      else
         alat=latmin
         do i=1,dimlat-1
            if ((lat.ge.alat).and.(lat.lt.alat+deltalat)) then
               dlat(4)=i+1
               dlat(3)=i+1
               dlat(1)=i
               dlat(2)=i
               u=(lat-alat)/deltalat
            endif
            alat=alat+deltalat
         enddo       
      endif

      return
      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine grwpb(dset,pert,rangw1,rangw2,dev,lamda,lon,lat,absheight,rho,u,v,ps,sigma, & 
                       utime,name,ier,itimint,wl,wh,R_gcm,temp_gcm,sheight,p_pgcm,ps_psgcm)

!     Small scale gravity wave perturbation model.
!     Computes perturbation on u, v, theta or rho, with wave phase factor.
!
!     Last updated Feb. 2008: improved behaviour when near surface (in order
!                             to get rid of 'jumps' in perturbations when run
!                             at very fine resolution)

      use MCD_var, only : dimlevs

      implicit none

!     inputs
      character*(*), intent(in) ::  dset              ! dataset directory
      real,          intent(in) ::  dev               ! phase of perturbation (rand number between 0 and 1)
      real,          intent(in) ::  rangw1,rangw2
      real,          intent(in) ::  lamda             ! vertical wavelength of g.w. (m)
      real,          intent(in) ::  lon               ! east longitude of point
      real,          intent(in) ::  lat               ! latitude of point
      real,          intent(in) ::  absheight         ! height (above surface) of point
      real,          intent(in) ::  rho               ! density at height=height
      real,          intent(in) ::  u                 ! zonal wind at height=height
      real,          intent(in) ::  v                 ! meridional wind at height=height
      real,          intent(in) ::  ps                ! surface pressure
      real,          intent(in) ::  sigma(dimlevs)    ! sigma levels 
      real,          intent(in) ::  utime             ! Universal time (0. to 24. hrs) = local time at lon=0
      integer,       intent(in) ::  itimint           ! seasonal interpolation flag
      real,          intent(in) ::  wl,wh             ! seasonal interpolation weights
      real,          intent(in) ::  R_gcm(dimlevs)    ! R at GCM levels
      real,          intent(in) ::  temp_gcm(dimlevs) ! temperature at GCM levels
      real,          intent(in) ::  sheight(dimlevs)  ! altitude of GCM sigma levels
      real,          intent(in) ::  p_pgcm(dimlevs)   ! high res to GCM pressure ratios
      real,          intent(in) ::  ps_psgcm          ! High res to GCM surface pressure ratio 
      character*18,  intent(in) ::  name              ! name of variable to perturb

!     outputs
      integer,      intent(out) ::  ier               ! error flag (0=OK, 1=NOK)
      real,         intent(out) ::  pert              ! perturbation

!     local variables
      ! zareoid,zpressure,zradius,zsurface only local
      ! we do not care of those variables here
      real         xz,zareoid,zpressure,zradius,zsurface,zmradius   
      integer      zkey
      integer      ierr
      real         a, aprime
      real         rho0,rho1
      real         u0,u1
      real         v0,v1
      real         tmpheight
      integer      levlow,levhi
      real         levweight(2)
      real         pratio
      real         dz,dz_max
      real         sig
      real         umag
      real         hmax    !for perturbations above hmax, use amplitude at hmax (m)
      parameter   (hmax=100.E3) 
      real         usat    !for windspeeds below usat, wave amplitude saturates
      Parameter   (usat=0.5)
      real         dalr    !dry adiabatic lapse rate (K/m)
      parameter   (dalr=4.5E-3)
      real         pi 
      parameter   (pi=3.14159265359)
      character*18 tmpname
      real         h,Dist
      real         lamda_D
      real, save :: prevrangw1=-999.
      real, save :: lat0,lon0
      real, parameter :: degtorad=pi/180.
      
!      write(out,*)""
!      write(out,*) "Entering grwpb, name:",name
!      write(out,*) "                dev=",dev
!      write(out,*) "                lamda=",lamda
!      write(out,*) "                absheight=",absheight
!      write(out,*) "                rho=",rho
!      write(out,*) "                u=",u
!      write(out,*) "                v=",v

      ier=0

!     1. get rho0, u0, v0
!        use mean data from level 1, not height=0.0
      levlow=1
      levhi=1
      levweight(1)=1.
      levweight(2)=1.
      pratio=1.0
      tmpname='u'
      call var3d(u0,lon,lat,sheight(1),levhi,levlow,levweight,pratio,sheight,  & 
                 p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)
      tmpname='v'
      call var3d(v0,lon,lat,sheight(1),levhi,levlow,levweight,pratio,sheight,  &
                 p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)
      tmpname='rho'
      call var3d(rho0,lon,lat,sheight(1),levhi,levlow,levweight,pratio,sheight,& 
                 p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)

!      write(out,*) "grwpb: u0=",u0," v0=",v0," rho0=",rho0 
      
!     get sub-grid scale variance
      tmpname='substd'
      call var2d(sig,lon,lat,1.0,tmpname,ierr,itimint,wl,wh,1.0)

!     2. Compute delta z, the vertical displacement
!        (note that here we assume N=N0, i.e. no change in Brunt Vaisala 
!          frequency between altitude 'absheight' and 1st layer)
      if (absheight.le.hmax) then
         umag=sqrt(u**2+v**2)
!        the wave amplitude becomes large as the wind speed becomes small
!        and the wave should saturate
         if (umag.lt.usat) umag=usat
!        *********************               
!         theoretical version:  
          dz=sig*sqrt((rho0*sqrt(u0**2+v0**2))/(rho*umag))
!        *********************               
!         Version 3 :  
!        dz=1.E3*sqrt((rho0*sqrt(u0**2+v0**2)*sig*1.E-3)/(rho*umag))
!        *********************               
         tmpheight=absheight
      else
!         perturbation above hmax km:
!         Using the same amplitude and same perturbation
!         as at hmax km for T,u,v. The perturbation for rho is
!         scaled on the T perturbation for rho at height=height     
         tmpheight=hmax          ! set height for perturbation calculation
!         get info on variable at hmax m:
         xz=tmpheight
         zkey=-5
         call getsi(xz,zkey,lon,lat,0.0,0.0,ps,sigma,utime,dset,levhi,levlow,levweight,pratio,ierr, & 
                    itimint,wl,wh,R_gcm,temp_gcm,zareoid,zradius,zsurface,zpressure,zmradius,sheight)
         tmpname='rho'
         call var3d(rho1,lon,lat,absheight,levhi,levlow,levweight,pratio,sheight, &
                    p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)
         tmpname='u'
         call var3d(u1,lon,lat,absheight,levhi,levlow,levweight,pratio,sheight,   &
                    p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)
         tmpname='v'
         call var3d(v1,lon,lat,absheight,levhi,levlow,levweight,pratio,sheight,   &
                    p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)
         umag=sqrt(u1**2+v1**2)
!        the wave amplitude becomes large as the wind speed becomes small
!        and the wave should saturate
         if (umag.lt.usat) umag=usat
!        dz=(rho0*sqrt(u0**2+v0**2)*sig)/(rho1*umag)
!        dz=sqrt(dz)
          dz=sig*sqrt((rho0*sqrt(u0**2+v0**2))/(rho1*umag))
      end if
!     lat0,lon0 coordinates from which the distance Dist is calculated
!     remain the same as long as the seed is not changed
      if (rangw1.ne.prevrangw1) then
         lat0=lat
         lon0=lon
         prevrangw1=rangw1
      endif      
!      Horizontal wavelength proportional to the vertical one
      lamda_D=10.*lamda
      h=(sin((lat-lat0)*degtorad/2.))**2+cos(lat0*degtorad)*cos(lat*degtorad)*(sin((lon-lon0)*degtorad/2.))**2
      Dist=(2.*3390.E3)*asin(sqrt(h))
!     apply simple test for saturation (require theta_z > 0)
!     and compute wave
!      write(*,*) "grwpb: lamda=",lamda
      dz_max=lamda/(2.*pi)
!     Random saturation to make the maximum amplitude of the wave vary
      dz_max=dz_max*(1.+3.*rangw2)       
      if (dz.gt.dz_max) then
         dz=dz_max
      endif
      dz=dz*sin(2.*pi*dev+(2.*pi*absheight)/lamda+(2.*pi*Dist)/lamda_D)  

!     3. Find perturbation from change delta z in mean profile
!     (more accurate than taking first derivative).
!     Using an oroheight of 0km in getsi here implies an insignificant
!     error in the calculated value of g used to find the distance to
!     the perturbation, very much smaller than other assumptions made
!     (interpolation, adiabatic, constant g, etc.).

!     don't allow dz to take us below the surface
!      if ((tmpheight+dz).le.0.) then
      if ((tmpheight+dz).le.0) then
! old version rescale underground to near-surface
!         dz = -0.99*tmpheight
! new version: mirror underground depths to above surface heights
        dz=-tmpheight-(tmpheight+dz)
      endif

! But, avoid being taken too close to the surface
      if ((tmpheight+dz).le.1000.) then
! map dz so that (tmpheight+dz) spans [100:1000] instead of [0:1000]
        dz=(((1000.0-100.0)/1000.0)*(tmpheight+dz)+100.0)-tmpheight
      endif

!      write(*,*) "grwpb: finally dz=",dz," tmpheight+dz=",tmpheight+dz

      tmpname = name
      if (name.eq.'rho') then
        ! density perturbation is computed from temperature perturbation
        ! (see below)
        tmpname= 'temp'
      endif
      
      ! get 'a': value of variable at altitude 'tmpheight'
      xz=tmpheight
      zkey=-5
      call getsi(xz,zkey,lon,lat,0.0,0.0,ps,sigma,utime,dset,levhi,levlow,levweight,pratio,ierr, &
                 itimint,wl,wh,R_gcm,temp_gcm,zareoid,zradius,zsurface,zpressure,zmradius,sheight)
      call var3d(a,lon,lat,xz,levhi,levlow,levweight,pratio,sheight,                             &
                 p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)
      
      ! get 'aprime': value of variable at altitude 'tmpheight+dz'
      xz=tmpheight+dz
      call getsi(xz,zkey,lon,lat,0.0,0.0,ps,sigma,utime,dset,levhi,levlow,levweight,pratio,ierr, &
                 itimint,wl,wh,R_gcm,temp_gcm,zareoid,zradius,zsurface,zpressure,zmradius,sheight)
      call var3d(aprime,lon,lat,xz,levhi,levlow,levweight,pratio,sheight,                        & 
                 p_pgcm,sigma,ps_psgcm,utime,tmpname,ierr,itimint,wl,wh)
      
      ! perturbation is just the difference between values at altitudes
      ! tmpheight and (tmpheight+dz) (with corrections for temperature
      ! and density)
      pert = aprime - a


!     correction for perturbation to potential temperature
      if (tmpname.eq.'temp') then
        pert = pert + dalr*dz
      endif

      ! reduce 'pert' if below 2000.0m (so that it smoothly goes to zero
      ! at surface)
      if (absheight.le.2000.0) then
        pert=pert*sin((absheight/2000.0)*(pi/2.))**2
      endif

!     correction for perturbation on density
!     pert(rho) = -rho*pert(T)/(T+pert(T))
      if (name.eq.'rho') then
         pert = -rho*pert/(a+pert)
      end if 

      ! if near the surface then quench perturbations

!      write(out,*) "grwpb: pert=",pert
      return
      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine loadvar_mcd(nf,nf_up,nf2,nf_up2,typevar,aps,bps,sigma,pseudoalt,ier)

!     load arrays corresponding to the variable typevar

      use netcdf
      
      use MCD_var, only : dimlevs, dimlon, dimlat, low, up, nbcomsd, nbcom, nbvarlow, nbvar3d, nbsd2d, nbsd3d, &
                          nbsdlow, nbvar2d, varname2d, varname3d, pref, out, output_messages,                  &
                          taborog, tabareo, tabz0, tabti, tabga, tabwc, tabsubstd
      
      implicit none
      
! variable typevar to load :
! 2D LOW mean = tsurf,ps,co2ice,fluxsurf_lw,fluxtop_lw,fluxsurf_sw,
!               fluxtop_sw,dod,col_h2ovapor,col_h2oice! 2D values
!               q2,vmr_h2ovapor,vmr_h2oice,vmr_o3,temp,u,v,rho ! 3D low (nf=unem)
! UP     mean = temp,u,v,w,rho,vmr_o,vmr_co2,_vmr_co !3D up (nf=unem_up)
!        sigm = sigma values of mean field file (nf=unetm)
!        orog = orography values of mountain file (nf=unet)
!        eofs = normu,normu,normt,normp,normr,u,v,t,rho,ps,pcsmth,pcvar
!               of eof field file (nf=ueof) 
!        grwp = substd values of mountain file (nf=unet)
! 2D&LOW stdv = tsdtsurf,tsdps,tsddod, !2D
!               tsdtemp,tsdsu,tsdsv,tsdrho !3D low values of
!               standard deviation field file (nf=unetsd)
! 2D&LOW rms  = rmstsurf,rmsps,rmsco2ice, !2D
!               rmstemp,rmsu,rmsv,rmsrho !3D low values of
!               rms field file (nf=unetsd)
! UP     stdv = tsdtemp,tsdsu,tsdsv,tsdw,tsdrho !3D up values of 
!               standard deviation field file (nf=unetsd_up)
! UP     rms  = rmstemp,rmssu,rmssv,rmsw,rmsrho !3D up values of 
!               rms field file (nf=unetsd_up)

!     inputs
      integer,          intent(in) :: nf,nf_up,nf2,nf_up2 ! NetCDF file IDs
      character(len=*), intent(in) :: typevar             ! variable 'type'

!     outputs      
      real,             intent(out) :: aps(dimlevs)       ! hybrid coordinate
      real,             intent(out) :: bps(dimlevs)       ! hybrid coordinate
      real,             intent(out) :: sigma(dimlevs)     ! sigma levels
      real,             intent(out) :: pseudoalt(dimlevs) ! pseudo altitude
      integer,          intent(out) :: ier                ! error flag (0=OK, 1=NOK)

!     local variables 
      character*18 name ! variable name    
      integer      ierr
      integer      varid ! NetCDF variable ID
      integer      l,k,iloop,jloop
      real         aps_low(low),bps_low(low) ! hybrid coord.
      real         aps_up(up) ! hybrid coord. upper atm.

      ! 2D variables with RMS
      character*50 sd2d(nbsd2d)  /  'tsurf','ps','tau_pref_gcm'/
      ! 3D variables with RMS (pressure-wise and altitude-wise)
      character*50 sd3d(nbsd3d+1) / 'temp','u','v','rho','w','pressure'/
      
      real temp2d(dimlon,dimlat) ! temporary array

      if (typevar.eq.'mean') then

! MEAN 2d 
        do k=1,nbvar2d
          call get_2d(nf,k,varname2d(k),1)
          call get_2d(nf2,k,varname2d(k),2)
        enddo
! MEAN  only in low file! up data extrapolated 
        do k=1,nbvarlow-nbcom
          call get_3d(nf,k,varname3d(k),low,1)
          call get_3d(nf2,k,varname3d(k),low,2)
          call extrapol3d(typevar,k,up,pseudoalt)
        enddo
! MEAN up and low COMMON
        do k=nbvarlow-nbcom+1,nbvarlow
          call get_3d(nf,k,varname3d(k),low,1)
          call get_3d(nf2,k,varname3d(k),low,2)
          call get_3d(nf_up,k,varname3d(k),up,1)
          call get_3d(nf_up2,k,varname3d(k),up,2)
        enddo
! MEAN up - low data extrapolated 
        do k=nbvarlow+1,nbvar3d
          call get_3d(nf_up,k,varname3d(k),up,1)
          call get_3d(nf_up2,k,varname3d(k),up,2)
          call extrapol3d(typevar,k,low,pseudoalt)
        enddo

      elseif (typevar.eq.'hybr') then

        name='aps'
        ierr = nf90_inq_varid(nf_up,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf_up,varid,aps_up)
        if (ierr.ne.nf90_noerr) goto 9999

! if low atmosphere, need aps and bps         
        name='aps'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,aps_low)
        if (ierr.ne.nf90_noerr) goto 9999
        name='bps'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,bps_low)
        if (ierr.ne.nf90_noerr) goto 9999

!       hybrid coordinates: aps() and bps()
        do l=1,low
          aps(l)=aps_low(l)
          bps(l)=bps_low(l)
        enddo
        do l=low+1,dimlevs
          aps(l)=aps_up(l-low)
          bps(l)=0
        enddo

!       pseudoalt:
        do l=1,dimlevs
          pseudoalt(l)=-10*log(aps(l)/pref+bps(l))
        enddo
             
!       sigma Thermosphere : !!! not used any more
!        sigma(dimlevs+1) = sigma(dimlevs)*exp(-20./7.)  
         
      elseif (typevar.eq.'orog') then

        name='orography'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,temp2d)
        if (ierr.ne.nf90_noerr) goto 9999
        do jloop=1,dimlat
          do iloop=1,dimlon ! taborog() is a common in constants_mcd.inc
           taborog(iloop,jloop,1)=temp2d(iloop,dimlat+1-jloop) 
          enddo
        enddo
        
        name='areoid'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,temp2d)
        if (ierr.ne.nf90_noerr) goto 9999
        do jloop=1,dimlat
          do iloop=1,dimlon ! tabareo() is a common in constants_mcd.inc
           tabareo(iloop,jloop,1)=temp2d(iloop,dimlat+1-jloop) 
          enddo
        enddo
        
      elseif (typevar.eq.'surf') then

        name='z0'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,temp2d)
        if (ierr.ne.nf90_noerr) goto 9999
        do jloop=1,dimlat
          do iloop=1,dimlon ! tabareo() is a common in constants_mcd.inc
           tabz0(iloop,jloop,1)=temp2d(iloop,dimlat+1-jloop) 
          enddo
        enddo

        name='inertiedat'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,temp2d)
        if (ierr.ne.nf90_noerr) goto 9999
        do jloop=1,dimlat
          do iloop=1,dimlon ! tabareo() is a common in constants_mcd.inc
           tabti(iloop,jloop,1)=temp2d(iloop,dimlat+1-jloop) 
          enddo
        enddo

        name='albedodat'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,temp2d)
        if (ierr.ne.nf90_noerr) goto 9999
        do jloop=1,dimlat
          do iloop=1,dimlon ! tabareo() is a common in constants_mcd.inc
           tabga(iloop,jloop,1)=temp2d(iloop,dimlat+1-jloop) 
          enddo
        enddo

        name='watercaptag'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,temp2d)
        if (ierr.ne.nf90_noerr) goto 9999
        do jloop=1,dimlat
          do iloop=1,dimlon ! tabareo() is a common in constants_mcd.inc
           tabwc(iloop,jloop,1)=temp2d(iloop,dimlat+1-jloop) 
          enddo
        enddo


      elseif (typevar.eq.'grwp') then

        name='substd'
        ierr = nf90_inq_varid(nf,name,varid) 
        if (ierr.ne.nf90_noerr) goto 9999
        ierr = nf90_get_var(nf,varid,temp2d)
        if (ierr.ne.nf90_noerr) goto 9999
        do jloop=1,dimlat
          do iloop=1,dimlon ! tabsubstd() is a common in constants_mcd.inc
           tabsubstd(iloop,jloop,1)=temp2d(iloop,dimlat+1-jloop) 
          enddo
        enddo

      elseif (typevar.eq.'rms') then

! RMS 2d 
        do k=1,nbsd2d
          call getsd_2d(nf,typevar,k,"rms"//sd2d(k),1)
          call getsd_2d(nf2,typevar,k,"rms"//sd2d(k),2)
        enddo
! RMS low - up data extrapolated
!      call getsd_3d(nf,typevar,1,nbsdlow-nbcomsd,"tsd"//sd3d(k),
!     $ low) 
! RMS up and low 
        do k=nbsdlow-nbcomsd+1,nbsdlow  
          call getsd_3d(nf,typevar,k,"rms"//sd3d(k),low,1)
          call getsd_3d(nf2,typevar,k,"rms"//sd3d(k),low,2)
          call getsd_3d(nf_up,typevar,k,"rms"//sd3d(k),up,1)
          call getsd_3d(nf_up2,typevar,k,"rms"//sd3d(k),up,2)
        enddo
! RMS up - low data extrapolated 
!        WARNING : uncomment these lines if to have a rms only in the
!        low atm (not the case in version 4)
!        do k=nbsdlow+1,nbsd3d
!         call getsd_3d(nf_up,typevar,k,"rms"//sd3d(k),up,1)
!         call getsd_3d(nf_up2,typevar,k,"rms"//sd3d(k),up,2)
!         call extrapol3d(typevar,k,low)
!        enddo

      elseif (typevar.eq.'arms') then
! Altitude-wise RMS
        do k=nbsdlow-nbcomsd+1,nbsdlow+1 ! +1 because we also want pressure
          call getsd_3d(nf,typevar,k,"arms"//sd3d(k),low,1)
          call getsd_3d(nf2,typevar,k,"arms"//sd3d(k),low,2)
          call getsd_3d(nf_up,typevar,k,"arms"//sd3d(k),up,1)
          call getsd_3d(nf_up2,typevar,k,"arms"//sd3d(k),up,2)
!          write(out,*)'k=',k,'vararms3d(2,48,2,k)=',vararms3d(2,48,2,k)
        enddo

      endif ! of if (typevar.eq.'mean') elseif ...

      return

!     Error handling
 9999 ier=16
      if (output_messages) then
        write(out,*)"loadvar_mcd Error : impossible to load ",name," from ",typevar, "value file"
      endif
      return
      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       subroutine loadeof(nf,rdeof,dust,dataset,ier)

!     load EOF arrays (which are commons in 'constants_mcd.inc')

      use netcdf

      use MCD_var, only : tabeonormp,tabeonormt,tabeonormu,tabeonormv,tabeops,tabeot,tabeou,tabeov,tabpc,tabpcsmth,&
                          output_messages,out

      implicit none
     
!     inputs
      real,             intent(in)    ::  rdeof   ! uniform random number in [0,1] for EOF perturb.
      integer,          intent(in)    ::  dust    ! dust scenario
      character(len=*), intent(in)    ::  dataset ! path to datafiles
      integer,          intent(inout) ::  nf      ! NetCDF file ID (file may have been previously opened)

!     outputs
      integer,          intent(out)   ::  ier     ! error flag (0=OK, 1=NOK)

      character*18 name ! name of variable to read
      integer ierr      ! NetCDF routine (returned) status
      integer varid     ! NeCDF identifier
      character(len=45) :: datafile
      integer :: EOFyear ! EOF scenario
      integer, save :: EOFyear_prev=0 ! previous EOF scenario
      real :: rdeof2 ! random (between 0 and 1) generated from rdeof

      ! initialize ier to zero
      ier=0
      
      ! When using the dust=1-3 scenarios, there is now the possibility that we
      ! will swich between EOF files
      EOFyear=dust ! general case, the EOF scenario is the same as the dust scenario
      
      if ((dust.ge.1).and.(dust.le.3)) then
        ! build rdeof2 from rdeof, as the third (and following) digits
        ! of rdeof, and have it be between 0 and 1.
        rdeof2=100.*rdeof-floor(100.*rdeof)
!        write(*,*) "loadeof: rdeof=",rdeof," rdeof2=",rdeof2
        ! depending on rdeof2, we swich between EOF scenarios
        if (rdeof2.lt.1./7.) then
          EOFyear=2 ! MY24 scenario
        elseif (rdeof2.lt.2./7.) then
          EOFyear=4 ! MY26 scenario
        elseif (rdeof2.lt.3./7.) then
          EOFyear=5 ! MY27 scenario
        elseif (rdeof2.lt.4./7.) then
          EOFyear=7 ! MY29 scenario
        elseif (rdeof2.lt.5./7.) then
          EOFyear=8 ! MY30 scenario
        elseif (rdeof2.lt.6./7.) then
          EOFyear=9 ! MY31 scenario
        else
          EOFyear=10 ! MY32 scenario
        endif
        ! NB: we for now voluntarily do not include MY33 EOFs
        !     (for consitency within MCDv5.3 versions)
      endif

      if (EOFyear.ne.EOFyear_prev) then
        ! we need to load some EOF data:
        ierr=nf90_close(nf) ! close a possibly previously opened file
        ! which EOF datafile ?
        if ((dust.ge.1).and.(dust.le.3)) then ! clim scenarios
          if (EOFyear.eq.2) datafile="clim_aveEUV/MY24_all_var_eo.nc"
          if (EOFyear.eq.3) datafile="clim_aveEUV/MY25_all_var_eo.nc"
          if (EOFyear.eq.4) datafile="clim_aveEUV/MY26_all_var_eo.nc"
          if (EOFyear.eq.5) datafile="clim_aveEUV/MY27_all_var_eo.nc"
          if (EOFyear.eq.6) datafile="clim_aveEUV/MY28_all_var_eo.nc"
          if (EOFyear.eq.7) datafile="clim_aveEUV/MY29_all_var_eo.nc"
          if (EOFyear.eq.8) datafile="clim_aveEUV/MY30_all_var_eo.nc"
          if (EOFyear.eq.9) datafile="clim_aveEUV/MY31_all_var_eo.nc"
          if (EOFyear.eq.10) datafile="clim_aveEUV/MY32_all_var_eo.nc"
        elseif (dust.eq.4) then
          datafile="strm/strm_all_min_eo.nc"
        elseif (dust.eq.5) then
          datafile="strm/strm_all_ave_eo.nc"
        elseif (dust.eq.6) then
          datafile="strm/strm_all_max_eo.nc"
        elseif (dust.eq.7) then
          datafile="warm/warm_all_max_eo.nc"
        elseif (dust.eq.8) then
          datafile="cold/cold_all_min_eo.nc"
        else if ((dust.ge.24).and.(dust.le.35)) then
          datafile=""
          ! NB these files are stored in clim_aveEUV
          write(datafile,'(a14,i2,a14)')"clim_aveEUV/MY",dust,"_all_var_eo.nc"
        else
          ! no corresponding EOF file!
          goto 9999
        endif
        
        ! open EOF datafile:
        if (output_messages) then
          write(out,*) "Opening ",trim(dataset)//trim(datafile)
        endif
        ierr=nf90_open(trim(dataset)//trim(datafile),nf90_nowrite,nf)
        if ((ierr.ne.nf90_noerr).and.output_messages) then
          write(*,*) "Failed to open ",trim(dataset)//trim(datafile)
          write(*,*) nf90_strerror(ierr)
!        else
!          write(*,*) "OK: opened ",trim(dataset)//trim(datafile)
        endif

        if (ierr.ne.nf90_noerr) goto 9999
        
        ! load dataset
         ! Norm verctor for u
         name='normu'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeonormu)
         if (ierr.ne.nf90_noerr) goto 9999
       
         ! Norm vector for v
         name='normv'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeonormv)
         if (ierr.ne.nf90_noerr) goto 9999
       
         ! Norm vector for temperature
         name='normt'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeonormt)
         if (ierr.ne.nf90_noerr) goto 9999
       
         ! Norm vector for surface pressure
         name='normp'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeonormp)
         if (ierr.ne.nf90_noerr) goto 9999
       
!         name='normr'
!         ierr = nf90_inq_varid(nf,name,varid)
!         if (ierr.ne.nf90_noerr) goto 9999
!         ierr = nf90_get_var(nf,varid,tabeonormr)
!         if (ierr.ne.nf90_noerr) goto 9999
       
         ! zonal velocity
         name='u'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeou)
         if (ierr.ne.nf90_noerr) goto 9999
       
         ! meridional velocity
         name='v'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeov)
         if (ierr.ne.nf90_noerr) goto 9999
       
         ! atmospheric tempeerature
         name='temp' 
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeot)
         if (ierr.ne.nf90_noerr) goto 9999
       
         ! density
!         name='rho'
!         ierr = nf90_inq_varid(nf,name,varid)
!         if (ierr.ne.nf90_noerr) goto 9999
!         ierr = nf90_get_var(nf,varid,tabeorho)
!         if (ierr.ne.nf90_noerr) goto 9999
       
         ! surface pressure
         name='ps'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabeops)
         if (ierr.ne.nf90_noerr) goto 9999
       
         ! principal components
         name='pc'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabpc)
         if (ierr.ne.nf90_noerr) goto 9999

         ! smoothed principal components
         name='pcsmth'
         ierr = nf90_inq_varid(nf,name,varid)
         if (ierr.ne.nf90_noerr) goto 9999
         ierr = nf90_get_var(nf,varid,tabpcsmth)
         if (ierr.ne.nf90_noerr) goto 9999
       
!         name='pcvar'
!         ierr = nf90_inq_varid(nf,name,varid)
!         if (ierr.ne.nf90_noerr) goto 9999
!         ierr = nf90_get_var(nf,varid,tabpcvar)
!         if (ierr.ne.nf90_noerr) goto 9999

        EOFyear_prev=EOFyear
      endif ! of if (EOFyear.ne.EOFyear_prev)

        return 
!     Error handling
 9999 ier=16
      if (output_messages) then
        write(out,*)"LOADEOF Error : failed to load ",trim(name)," from eof file ",trim(datafile)
      endif
      return

        end
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine mars_ltime(lon,jdate,ls,localtime,lmeantime)

!     Compute local true solar time at longitude=lon (in deg. east)
!     at julian date jdate, also given in Ls.

      implicit none
      
      ! Inputs
      real,  intent(in) :: lon         ! east longitude (in deg.)
      real*8,intent(in) :: jdate       ! julian date
      real,  intent(in) :: ls          ! aerocentric longitude (in deg.)
      
      ! Output     
      real,   intent(out) :: localtime ! local true solar time (in martian hours)
      real,   intent(out) :: lmeantime ! local mean solar time (martian hours)

!     local variables
      double precision  LMT_0,E_T,LTST_0
      !double precision, external ::  Mars_LMT0
! marsday: number of seconds in a sol (matian day)
!      double precision     marsday
!      parameter (marsday=88775.245d0)
!  earthday: number of seconds in a day: 24*60*60
!      double precision     earthday
!      parameter (earthday=86400.d0)
! julian date of reference date: 01-01-1976 at 00:00:00
!      double precision     jdate_ref
!      parameter (jdate_ref=2442778.5d0) 
! LMT_ref: mean solar time at 0 deg. longitude at date jdate_ref
!      double precision    LMT_ref ! in martian hours
!      parameter (LMT_ref=16.1725d0) ! 01-01-1976 at 00:00:00
! orbital eccentricity
      double precision    eccentricity
      parameter (eccentricity=0.0934d0)
! Ls of perihelion (in degrees)
      double precision    Ls_peri
      parameter (Ls_peri=250.99d0)
! obliquity of equator to orbit (in deg.)
      double precision    obliquity
      parameter (obliquity=25.1919d0)
      double precision    pi,degtorad
      parameter (pi=3.14159265358979d0)
      parameter (degtorad=pi/180.0d0)

! compute LMT, local mean time, (in martian hours) at longitude 0
!      LMT_0=LMT_ref+24.0*(jdate-jdate_ref)*(earthday/marsday)
!      do while(LMT_0.le.0.d0) ! in case jdate<jdate_ref
!        LMT_0=LMT_0+24.0d0
!      enddo
!      LMT_0=dmod(LMT_0,24.0d0)
! a slightly more accurate computation of LMT_0
       LMT_0=Mars_LMT0(jdate)

! compute equation of time (see eq. 10.17, p.419 in
! "satellites orbits and missions", by M. Capderou),
! with a 24/(2*pi) factor to express it in martian hours
      E_T=(2.d0*eccentricity*dsin((ls-Ls_peri)*degtorad)-dtan(obliquity*degtorad/2.0)* & 
           dtan(obliquity*degtorad/2.0)*dsin(2.0*ls*degtorad))*24.0d0/(2.0*pi)


! compute true solar time at longitude 0
      LTST_0=LMT_0-E_T

! compute local true solar time at longitude lon
      localtime=real(LTST_0) + (lon/15.0)
      localtime=mod(24.0+localtime,24.0)

! compute local mean solar time at longitude lon
      lmeantime=real(LMT_0) + (lon/15.0)
      lmeantime=mod(24.0+lmeantime,24.0)
      
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      double precision function Mars_LMT0(djul)
      ! Compute local mean solar time on Mars at lon=0 in Mars hours (and
      ! decimal fraction thereof) for a given Julian date
      !
      ! Form M. Capderou, using references M. Allison & M. McEwen (Mars24)
      ! and computations from J. Tauber, Observatoire de Paris
      !
      ! Uses the fact that Julian date 2451549.5 (midnight at Greenwich)
      ! corresponds to almost midnight (23:59:39) LMT at Airy0 crater
      ! With 44796 added to avoid negative values (start of MSD)
      !
      ! Factor a1 from Allison & McEwen.
      ! Factors a2 and a3 added by M. Capderou
      ! for a better match with Mars24 outputs in the "modern era".
      ! Accurate to the second or less for years 1950 to 2050 (wrt Mars24).

      implicit none
      double precision, intent(in) :: djul ! julian date
      double precision, parameter :: dj2000=2451545.0d0
      double precision, parameter :: coeff=1.02749125d0 ! length of sol in days
      double precision :: a1,a2,a3,atot
      double precision :: x,y,xt,xanterre
      
      a1=7.2d-4
      xt=djul-(dj2000+4.5)
      x=xt/coeff
      x=x+44796.0d0-a1
      y=x-int(x)
      y=y*24.d0  ! Martian hours
      
      ! Small corrections to better fit to Mars24
      a2=41.0d0
      xanterre=(djul-dj2000)/365.25 ! Earth years wrt 01/01/2000
      if (xanterre.lt.0) then
        a3=28.5/45.*(0.-xanterre)+0.5
      else
        if (xanterre.lt.20.) then
          a3=3./20.*(20.-xanterre)-2.5
        else
          a3=-1
        endif
      endif
      atot=a2-a3
      atot=atot/3600.d0 ! Martian hours
      
      Mars_LMT0=y+atot
      
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine mars_ptime(lon,lt,ut)

!     Convert local true solar time, lt (0..24) at east longitude (in deg.) 
!     into "universal time"  ut (0..24), the local true solar time at lon=0

      implicit none
      
!     inputs
      real, intent(in) :: lon    ! longitude east (in degrees)
      real, intent(in) :: lt     ! local time (in martian hours)
      
!     output
      real, intent(out):: ut     ! universal time  (local true solar time at lon=0)


      ut=mod(24.0+lt-lon/15.0,24.0)

      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine mcd_time(ut,itime,w)
      
!     From universal time ut (0..24 hrs) , find the 
!     2 nearest timestep in the database (1 - 12) 
!     and give the linear interpolation weight of itime(1)
! 
!     Note that it is midnight universal time (and thus at longitude=0.0)
!     at itime = 12

      implicit none

!     input
      real,    intent(in)  :: ut         ! universal time (0. to 24. hrs) =local time at lon=0

!     outputs
      integer, intent(out) ::  itime(2)  ! 2 nearest timestep in database 
      real,    intent(out) ::  w         ! linear interpolation weight of itime(1) / ie: w=1 if ut=itime(1) and w=0 if ut=itime(2)

      itime(1) = int(ut/2.)
      if (itime(1).eq.0) itime(1) = 12
      itime(2) = itime(1) +1
      if (itime(2).ge.13.) itime(2) = itime(2) -12

      w = 1 - ut/2. + int(ut/2.)
      
      return
      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine opend(unet,unetm,unetsd,unetm_up,unetsd_up,num,dust,dset,ier)

!     Open the appropriate NETCDF file corresponding to Ls, dust scenario  
!     and data set.
!     
!     Sept. 2012. Scenario files are now in individual subdirectories
!     April 2008. Added search for 'datafile.gz' in same directory in case
!                'datafile' is not found. EM

      use netcdf

      use MCD_var, only : out, output_messages

      implicit none

!     inputs
! NETCDF channels number      
      integer,       intent(inout)  ::  unet      ! for mountain fields
      integer,       intent(inout)  ::  unetm     ! for mean fields
      integer,       intent(inout)  ::  unetsd    ! for STD and RMS deviation fields
      integer,       intent(inout)  ::  unetm_up  ! for mean fields in thermosphere 
      integer,       intent(inout)  ::  unetsd_up ! for STD and RMS fields in thermosphere 

      integer,       intent(in)  ::  num       ! season num
      integer,       intent(in)  ::  dust      ! Dust senario
      character*(*), intent(in)  ::  dset      ! Dataset

!     output
      integer,       intent(out) ::  ier       ! Error flag (0=OK, 1=NOK)

!     local variables
      integer       ierr     ! return code from NetCDF functions
      character*258 datfile  ! directory where data is to be found
      character*4   scen     ! dust scenario name ('clim','cold', 'warm' or 'strm')
      character*12  scenlow  ! dust scenario directory
                             ! for lower atm ('cold','warm',etc.)
      character*12  scenup   ! dust scenario directory
                             ! for upper atm ('cold','warm',etc.)
      character*3   solar    ! EUV scenario ('min' or 'ave' or 'max')
      character*2   saison   ! month # (from '01' to '12')
      character*2   typ      ! type of datafile ('me' or 'sd' or 'eo')
      character*258 gzfile   ! 'datfile'//'.gz'
      
      ier=0
!     close files 
      ierr=nf90_close(unetm)
      ierr=nf90_close(unetsd)
      ierr=nf90_close(unetm_up)
      ierr=nf90_close(unetsd_up)
      ierr=nf90_close(unet)

!     dust scenario
      if (dust.eq.1.or.dust.eq.2.or.dust.eq.3) then
         scen='clim'
         scenlow='clim_aveEUV'
         if (dust.eq.1) then
           scenup='clim_aveEUV'
           solar='ave' 
         endif
         if (dust.eq.2) then
           scenup='clim_minEUV'
           solar='min' 
         endif
         if (dust.eq.3) then
           scenup='clim_maxEUV'
           solar='max'
         endif 
      elseif ((dust.eq.4).or.(dust.eq.5).or.(dust.eq.6)) then
         scen='strm'
         scenlow='strm'
         scenup='strm'
         if (dust.eq.4) solar='min' 
         if (dust.eq.5) solar='ave' 
         if (dust.eq.6) solar='max' 
      elseif (dust.eq.7) then
         scen='warm'
         scenlow='warm'
         scenup='warm'
         solar='max'
      elseif (dust.eq.8) then
         scen='cold'
         scenlow='cold'
         scenup='cold'
         solar='min'
      elseif ((dust.ge.24).and.(dust.le.35)) then
         write(scen,'(a2,i2)') "MY",dust
         write(scenlow,'(a2,i2)') "MY",dust
         write(scenup,'(a2,i2)') "MY",dust
         solar="var"
      else
         if (output_messages) then
           write(out,*) 'pb in opend with dust= ', dust
           write(out,*) '   no such scenario!'
         endif
         stop
      endif

!     season number
      write(saison,'(i2.2,1x)') num 

!     mean file
      typ='me'
      datfile=trim(dset)//trim(scenlow)//'/'//trim(scen)//'_'//saison//'_'//typ//'.nc'
      if (output_messages) then
        write(out,*) "Opening ",trim(datfile)
      endif
      ierr=nf90_open(datfile,nf90_nowrite,unetm)
      if (ierr.ne.nf90_noerr) then ! failed to open file
        ! check for a '.gz' version of the datafile
        gzfile=trim(dset)//trim(scenlow)//'/'//trim(scen)//'_'//saison//'_'//typ//'.nc.gz'
        open(40,file=gzfile,iostat=ierr,status="old")
        if (ierr.ne.nf90_noerr) then ! failed to open file.gz
          goto 9999
        else ! there is a file.gz around
          goto 8888
        endif
      endif

!     standard deviation file
      typ='sd'
      datfile=trim(dset)//trim(scenlow)//'/'//trim(scen)//'_'//saison//'_'//typ//'.nc'
      if (output_messages) then
        write(out,*) "Opening ",trim(datfile)
      endif
      ierr=nf90_open(datfile,nf90_nowrite,unetsd)
      if (ierr.ne.nf90_noerr) then ! failed to open file
        ! check for a '.gz' version of the datafile
        gzfile=trim(dset)//trim(scenlow)//'/'//trim(scen)//'_'//saison//'_'//typ//'.nc.gz'
        open(40,file=gzfile,iostat=ierr,status="old")
        if (ierr.ne.nf90_noerr) then ! failed to open file.gz
          goto 9999
        else ! there is a file.gz around
          goto 8888
        endif
      endif
      
!     thermo Mean file
      typ='me'
      datfile=trim(dset)//trim(scenup)//'/'//trim(scen)//'_'//saison//'_thermo_'//solar//'_'//typ//'.nc'
      if (output_messages) then
        write(out,*) "Opening ",trim(datfile)
      endif
      ierr=nf90_open(datfile,nf90_nowrite,unetm_up)
      if (ierr.ne.nf90_noerr) then ! failed to open file
        ! check for a '.gz' version of the datafile
        gzfile=trim(dset)//trim(scenup)//'/'//trim(scen)//'_'//saison//'_thermo_'//solar//'_'//typ//'.nc.gz'
        open(40,file=gzfile,iostat=ierr,status="old")
        if (ierr.ne.nf90_noerr) then ! failed to open file.gz
          goto 9999
        else ! there is a file.gz around
          goto 8888
        endif
      endif

!     thermo standard deviation file
      typ='sd'
      datfile=trim(dset)//trim(scenup)//'/'//trim(scen)//'_'//saison//'_thermo_'//solar//'_'//typ//'.nc'
      if (output_messages) then
        write(out,*) "Opening ",trim(datfile)
      endif
      ierr=nf90_open(datfile,nf90_nowrite,unetsd_up)
      if (ierr.ne.nf90_noerr) then ! failed to open file
        ! check for a '.gz' version of the datafile
        gzfile=trim(dset)//trim(scenup)//'/'//trim(scen)//'_'//saison//'_thermo_'//solar//'_'//typ//'.nc.gz'
        open(40,file=gzfile,iostat=ierr,status="old")
        if (ierr.ne.nf90_noerr) then ! failed to open file.gz
          goto 9999
        else ! there is a file.gz around
          goto 8888
        endif
      endif
      
!     mountain file
      datfile=dset//'mountain.nc'
      ierr=nf90_open(datfile,nf90_nowrite,unet)
      if (ierr.ne.nf90_noerr) goto 9999

      return

!     Error handling

 8888 ier=21    ! could not open file but found file.gz instead
      if (output_messages) then
        write(out,*)"Error in opend: cannot open file ",trim(datfile)
        write(out,*)"  but found file ",trim(gzfile)
        write(out,*)"  which should be uncompressed using third-party"//  &
                    " software (e.g. gunzip on Unix or Winzip on "//" Windows) to produce sought file."
      endif
      return
      
 9999 ier=15    ! could not open file (and no file.gz around)
      if (output_messages) then
        write(out,*)"Error in opend: cannot open file ",trim(datfile)
      endif
      return

      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine orbit(date,ls,marsau,outmodelday)

!     Given Julian date,compute Ls, sun-Mars distance
!     in AU and model day

      implicit none

!     input
      real*8, intent(in)  ::   date        ! Julian date

!     outputs
      real,   intent(out) ::   ls          ! Ls: Aerocentric longitude (in deg.)
      real,   intent(out) ::   marsau      ! Sun-Mars distance (in AU)
      real,   intent(out) ::   outmodelday ! Martian Day (0.-668.6)

!     local variables
      double precision     modelday
! marsday: number of seconds in a sol (matian day)
      double precision     marsday
      parameter (marsday=88775.245d0)
!  earthday: number of seconds in a day: 24*60*60
      double precision     earthday
      parameter (earthday=86400.d0)
      double precision     marsyear
      parameter (marsyear=668.5921d0) ! number of sols in a martian year
! julian date for 19-12-1975 at 4:00:00, at which Ls=0.0
      double precision jdate_ref
      parameter (jdate_ref=2442765.667d0)
      double precision pi,degtorad
      parameter (pi=3.14159265358979d0)
      parameter (degtorad=pi/180.0d0) 

      real       dummy

!     convert Julian day to model day
      modelday=(date-jdate_ref)*earthday/marsday
       do while(modelday.le.0.d0) !in case date<jdate_ref
         modelday=modelday+marsyear
       enddo
      modelday=dmod(modelday,marsyear)
      dummy=real(modelday)
      outmodelday=real(modelday)

      call sol2ls(dummy,ls)

! compute sun-mars distance (in AU)
      call sunmarsdistance(ls,marsau)

      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine sunmarsdistance(ls,marsau)
      ! compute Sun-Mars distance (in AU)
      
      implicit none
      
      real,intent(in)  :: ls     ! solar longitude (deg)
      
      real,intent(out) :: marsau ! Sun-Mars distance (AU)
      
      ! semi-major axis of orbit (in AU)
      double precision,parameter :: sma=1.52368d0
      ! orbital eccentricity
      double precision,parameter :: eccentricity=0.09340d0
      ! Ls of perihelion
      double precision,parameter :: Ls_peri=250.99
      double precision,parameter :: pi=3.14159265358979d0
      double precision,parameter :: degtorad=pi/180.0d0

      marsau=real(sma*(1.0d0-eccentricity*eccentricity)/(1.0d0+eccentricity*dcos((dble(ls)-Ls_peri)*degtorad)))

      end
      
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine solarzenithangle(lat,ls,localtime,solzenang)
      ! compute solar zenith angle
      implicit none
      
      real,intent(in) :: lat         ! latitude (deg)
      real,intent(in) :: ls          ! solar longitude (deg)
      real,intent(in) :: localtime   ! local true solar time (hours)
      
      real,intent(out) :: solzenang  ! (deg) solar zenith angle
      
      ! local variables:
      double precision :: declin ! declination of the Sun (rad)
      double precision,parameter :: obliquity=25.1919d0
      double precision,parameter :: pi=3.14159265358979d0
      double precision,parameter :: degtorad=pi/180.0d0
      double precision,parameter :: radtodeg=180.0d0/pi
      
      double precision :: mu0 ! cos of solar zenith angle
      
      ! Compute Sun's declination
      declin=asin(sin(ls*degtorad)*sin(obliquity*degtorad))
      
      ! Compute mu0
      mu0=sin(lat*degtorad)*sin(declin)+cos(lat*degtorad)*cos(declin)*cos(2.*pi*(localtime/24.-.5))
      
      solzenang=ACOS(mu0)*radtodeg
      
      end
      
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine season(ls,numsaison)

!     compute the season number for a given areocentric longitude

      implicit none

!     input
      real,    intent(in)  :: ls         ! solar longitude (deg)

!     output 
      integer, intent(out) :: numsaison  ! Martian Month (1-12)

      if ((ls.ge.0.0).and.(ls.le.30)) then
         numsaison=1
      endif
      if ((ls.ge.30.0).and.(ls.le.60)) then
         numsaison=2
      endif
      if ((ls.ge.60.0).and.(ls.le.90)) then
         numsaison=3
      endif
      if ((ls.ge.90.0).and.(ls.le.120)) then
         numsaison=4
      endif
      if ((ls.ge.120.0).and.(ls.le.150)) then
         numsaison=5
      endif
      if ((ls.ge.150.0).and.(ls.le.180)) then
         numsaison=6
      endif
      if ((ls.ge.180.0).and.(ls.le.210)) then
         numsaison=7
      endif
      if ((ls.ge.210.0).and.(ls.le.240)) then
         numsaison=8
      endif
      if ((ls.ge.240.0).and.(ls.le.270)) then
         numsaison=9
      endif
      if ((ls.ge.270.0).and.(ls.le.300)) then
         numsaison=10
      endif
      if ((ls.ge.300.0).and.(ls.le.330)) then
         numsaison=11
      endif
      if ((ls.ge.330.0).and.(ls.le.360)) then
         numsaison=12
      endif
      
      return
      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine season2(ls,numsaison,nums2,wl,wh,dust)

!     compute the 2 season numbers(nums,nums2) from areocentric longitude
!     for when itimint = 1, ie for seasonal interpolation
!     wl= lower season weighting, wh=higher season weighting

      implicit none

!     inputs
      real,    intent(in) :: ls
      integer, intent(in) :: dust

!     outputs 
      integer, intent(out) :: numsaison,nums2
      real,    intent(out) :: wl,wh

!     local variable
      real    lsc      

!     compute lower season
      numsaison=int((ls/30)+0.5)
      if (numsaison.eq.0) numsaison=12
!     compute higher season
      nums2=numsaison+1   
      if (nums2.eq.13) nums2=1
!     compute centre of season to find weightings
      lsc=((numsaison-1)*30)+15
      if (ls.lt.15) lsc=-15
!     compute weightings
      wh=(ls-lsc)/30.
      wl=1-wh

!     Dust storm scenario Special case for Ls near 180 and Ls near 360
      if ((dust.eq.4).or.(dust.eq.5).or.(dust.eq.6))then 
          if(numsaison.eq.6) numsaison=7
          if(nums2.eq.1) nums2=12
      endif 

      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine sol2ls(sol,ls)

!  convert a given martian day number (sol)
!  into corresponding solar longitude, Ls (in degr.),
!  where sol=0=Ls=0 is the
!  northern hemisphere spring equinox.

      implicit none

!     input 
      real, intent(in)  ::  sol

!     output 
      real, intent(out) ::  ls

!     local variables
      double precision    year_day,peri_day,timeperi,e_elips
      double precision    pi,radtodeg
! number of martian days (sols) in a martian year
      parameter (year_day=668.6d0)
! perihelion date (in sols)
      parameter (peri_day=485.35d0)
! orbital eccentricity
      parameter (e_elips=0.09340d0)
      parameter (pi=3.14159265358979d0)
!  radtodeg: 180/pi
      parameter (radtodeg=57.2957795130823d0)
!  timeperi: 2*pi*( 1 - Ls(perihelion)/ 360 ); Ls(perihelion)=250.99
      parameter (timeperi=1.90258341759902d0)

      double precision    zanom,xref,zx0,zdx,zteta,zz
!  xref: mean anomaly, zx0: eccentric anomaly, zteta: true anomaly        
      integer iter

      zz=(sol-peri_day)/year_day
      zanom=2.*pi*(zz-nint(zz))
      xref=dabs(zanom)

!  The equation zx0 - e * sin (zx0) = xref, solved by Newton
      zx0=xref+e_elips*dsin(xref)
      do 110 iter=1,10
         zdx=-(zx0-e_elips*dsin(zx0)-xref)/(1.-e_elips*dcos(zx0))
         if(dabs(zdx).le.(1.d-7)) then ! typically, 2 or 3 iterations are enough
           goto 120
         endif
         zx0=zx0+zdx
  110 continue
  120 continue
      zx0=zx0+zdx
      if(zanom.lt.0.) zx0=-zx0

! compute true anomaly zteta, now that eccentric anomaly zx0 is known
      zteta=2.*datan(dsqrt((1.+e_elips)/(1.-e_elips))*dtan(zx0/2.))

! compute Ls
      ls=real(zteta-timeperi)
      if(ls.lt.0.) ls=ls+2.*real(pi)
      if(ls.gt.2.*pi) ls=ls-2.*real(pi)
! convert Ls in deg.
      ls=real(radtodeg)*ls

      return
      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      real function ls2sol(ls)

!  Returns solar longitude, Ls (in deg.), from day number (in sol),
!  where sol=0=Ls=0 at the northern hemisphere spring equinox

      implicit none

!  Arguments:
      real, intent(in) :: ls

!  Local:
      double precision xref,zx0,zteta,zz
!        xref: mean anomaly, zteta: true anomaly, zx0: eccentric anomaly
      double precision year_day 
      double precision peri_day,timeperi,e_elips
      double precision pi,degrad 
      parameter (year_day=668.6d0) ! number of sols in a amartian year
!      data peri_day /485.0/
      parameter (peri_day=485.35d0) ! date (in sols) of perihelion
!  timeperi: 2*pi*( 1 - Ls(perihelion)/ 360 ); Ls(perihelion)=250.99
      parameter (timeperi=1.90258341759902d0)
      parameter (e_elips=0.0934d0)  ! eccentricity of orbit
      parameter (pi=3.14159265358979d0)
      parameter (degrad=57.2957795130823d0)

      if (abs(ls).lt.1.0e-5) then
         if (ls.ge.0.0) then
            ls2sol = 0.0
         else
            ls2sol = real(year_day)
         end if
         return
      end if

      zteta = ls/degrad + timeperi
      zx0 = 2.0*datan(dtan(0.5*zteta)/dsqrt((1.+e_elips)/(1.-e_elips)))
      xref = zx0-e_elips*dsin(zx0)
      zz = xref/(2.*pi)
      ls2sol = real(zz*year_day + peri_day)
      if (ls2sol.lt.0.0) ls2sol = ls2sol + real(year_day)
      if (ls2sol.ge.year_day) ls2sol = ls2sol - real(year_day)

      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine var2d(a,lon,lat,utime,name,ier,itimint,wl,wh,ps_psgcm)

!     Retrieve the value of 2-d variable 'name' at longitude=lon, latitude=lat 
!     and universal time=utime.
!     - Bilinear interpolation is used to interpolate variable to user
!       specified longitude and latitude. For surface pressure (name='ps'),
!       bilinear interpolation of log(pressure) is used.
!     - Linear interpolation is used to interpolate variable to user
!       specified time (of day) 'utime'.
!     - If (itimint>=1) then linear seasonal interpolation (with wl=weight 
!       of lower season and wh=weight of higher season) is then used.

      use MCD_var, only : nbvar2d, nbsd2d, varname2d, var_2d, var_2d2, out, output_messages, &
                          taborog, tabareo, tabsubstd, tabz0, tabti, tabga, tabwc,           &
                          varrms2d, varrms2d2

      implicit none
            
!     inputs
      real,         intent(in)  ::  lon       ! longitude (east) of point
      real,         intent(in)  ::  lat       ! latitude of point
      real,         intent(in)  ::  utime     ! Universal time (0. to 24. hrs) =local time at lon=0
      character*18, intent(in)  ::  name      ! Name of variable
      integer,      intent(in)  ::  itimint   ! seasonal interpolation flag / (==1 if seasonal interpolation is required)
      real,         intent(in)  ::  wl,wh     ! seasonal interpolation weights
      real,         intent(in)  ::  ps_psgcm  ! High res to GCM surface pressure ratio 

!     outputs
      integer,      intent(out) ::  ier       ! error flag (0=OK, 1=NOK)
      real,         intent(out) ::  a         ! value of variable

!     local variables
      real         at(2)    !seasonal interpolation variable  
      integer      i, j
      integer      k,sd,rms ! "flags" associated to variable 'name'
      integer      itime(2) ! nearest MCD time indexes
      integer      iut
      integer      dlon(4) ! nearest grid point longitude indexes
      integer      dlat(4) ! nearest grid point latitude indexes
      real         y(2,4)    ! to store nearest grid point values
      real         x(2,2)  ! bilinearly interpolated values ("lower" season)
      real         t,u   ! longitude and latitude-wise interpolation weights
      real         w     ! time-wise interpolation weight
      integer      itype,it
      
      ! rmsname(:) same ordering as  sd2d(:) in call_mcd with "rms" prefix
      character*15 rmsname(nbsd2d) /'rmstsurf','rmsps', 'rmstau_pref_gcm'/
      
      ier = 0

!      write(*,*)"var2d: name=",trim(name)

!     find nearest 4 grid points
      call grid4(lon,lat,dlon,dlat,t,u)
!     dlon() and dlat() now contain longitude and latitude indexes
!     and t and u (interpolation weights) are consequently set
!      write(*,*)"var2d: dlon=",dlon," dlat=",dlat
!      write(*,*)"var2d: t=",t," u=",u

!     find nearest 2 timestep :
      call mcd_time(utime,itime,w)
!      write(*,*)"var2d: itime=",itime," w=",w

!     flags sd and rms initialized to 999
      k=0
      sd=999 
      rms=999

!     Associate numbers with variable name to read loaded variable
!     (note these should be compatible with what is stated in 'loadvar_mcd')
!     ------------------------------------------------------------
      do itype=0,1
       if(itype.eq.0) then
        do k=1,nbvar2d
         if(name.eq.varname2d(k)) then
          sd = 0   
          goto 1111   
         endif     
        enddo    
       else
        do k=1,nbsd2d
         if(name.eq.rmsname(k)) then
          rms = 1   
          goto 1111   
         endif    
        enddo   
       endif   
      enddo      
      
      if((name.ne.'orography').and.(name.ne.'z0').and.(name.ne.'areoid').and.(name.ne.'substd').and. &
         (name.ne.'water_cap').and.(name.ne.'thermal_inertia').and.(name.ne.'ground_albedo')) then
!        CASE of an unexpected name (orography, areoid, z0, and substd
!             are treated below)
       if(output_messages) then
         write(out,*) 'problem using subroutine var2d : the name ',name
         write(out,*) 'is not recognized'
       endif
       stop
      endif       
     
1111  continue

      do it=1,2
 
! it=1 Retrieving variable for "lower" season
! it=2 Retrieving variable for "higher" season (if seasonal interpolation)
!     --------------------------------------
! Note: Arrays taborog(), tabsubstd(), var_2d(),....
!       are known from "constants_mcd.inc" and have been previously filled
!     loop on the 2 nearest timestep :
      do j = 1 , 2
         iut = itime(j)

!     retrieve the four values at the nearest grid points from the array
          if (name.eq.'orography') then
            do i=1,4
               y(it,i)=taborog(dlon(i),dlat(i),1)
            enddo
          elseif (name.eq.'areoid') then
            do i=1,4
               y(it,i)=tabareo(dlon(i),dlat(i),1)
            enddo
          elseif (name.eq.'substd') then
            do i=1,4
               y(it,i)=tabsubstd(dlon(i),dlat(i),1)
            enddo
          elseif (name.eq.'z0') then
            do i=1,4
               y(it,i)=tabz0(dlon(i),dlat(i),1)
            enddo
          elseif (name.eq.'thermal_inertia') then
            do i=1,4
               y(it,i)=tabti(dlon(i),dlat(i),1)
            enddo
          elseif (name.eq.'ground_albedo') then
            do i=1,4
               y(it,i)=tabga(dlon(i),dlat(i),1)
            enddo
          elseif (name.eq.'water_cap') then
            do i=1,4
               y(it,i)=tabwc(dlon(i),dlat(i),1)
            enddo                                     
          elseif (sd.eq.0) then
           if(it.eq.1) then  
            do i=1,4
              y(it,i)=var_2d(dlon(i),dlat(i),iut,k)
            enddo
           else
            do i=1,4
              y(it,i)=var_2d2(dlon(i),dlat(i),iut,k)
            enddo   
           endif 
          elseif (rms.eq.1) then
            if(it.eq.1) then  
             do i=1,4
               y(it,i)=varrms2d(dlon(i),dlat(i),k)
             enddo
            else
              do i=1,4
               y(it,i)=varrms2d2(dlon(i),dlat(i),k)
             enddo  
            endif    
          endif
!!         ----------------------------------------------------------
!!         Temporay patch correction for surface water ice for MCD 5.3
!!         FF 2020
!          if (name.eq.'h2oice') then
!            do i=1,4
!              if((dlat(i).gt.4).and.(dlat(i).lt.46)) then
!                if ((abs(y(it,i)-0.5).lt.1.E-6)
!     &                 .or.
!     &         (((y(it,i)-1.0/3.).gt.-1.E-7).and.
!     &           ((y(it,i)-1.0/3.).lt.5.E-3))
!     &                 .or.
!     &         (((y(it,i)-0.5/3.).gt.-1.E-7).and.
!     &          ((y(it,i)-0.5/3.).lt.5.E-3))
!     &                ) then
!
!!              only change ice values if neighbour points are not icy
!                    if(.not.(((y(it,1).gt.0.05).and.(y(it,1).lt.0.16))
!     &             .or.((y(it,2).gt.0.05).and.(y(it,2).lt.0.16))
!     &             .or.((y(it,3).gt.0.05).and.(y(it,3).lt.0.16))
!     &             .or.((y(it,4).gt.0.05).and.(y(it,4).lt.0.16))))
!     &              y(it,i)=0.
!                end if
!              end if
!            end do
!          end if
!!         ----------------------------------------------------------
          
          if ((name.eq.'ps').or.(name.eq.'rmsps')) then
!         bilinear interpolation of log(surface pressure)
            x(it,j)=(1.-t)*(1.-u)*log(y(it,1))+t*(1.-u)*log(y(it,2))+t*u*log(y(it,3))+(1.-t)*u*log(y(it,4))
            x(it,j)=exp(x(it,j))            
          else
!         bilinear interpolation in space
            x(it,j)=(1.-t)*(1.-u)*y(it,1)+t*(1.-u)*y(it,2)+t*u*y(it,3)+(1.-t)*u*y(it,4)
          endif
      end do ! of do j=1,2 loop

!     linear interpolation in time:
      at(it) = w*x(it,1) + (1-w)*x(it,2)
            
      if (itimint.lt.1) exit
      
      enddo ! of do it=1,2
      
      if (itimint.ge.1) then
!     Season interpolation between the two seasons
!     --------------------------------------------        
       a = wl*at(1) + wh*at(2)
      else
       a = at(1)
      endif 

!     Multiply (ie: rescale) by ps_psgcm for some variables
      ! NB: 'tauref' is dod (dust optical depth) at 610 Pa.
      !    so we don't need to rescale it
!      if ((name.eq.'tauref').or.(name.eq.'rmstauref').or.
!     &    (name.eq.'rmsps').or.
!     &    (name.eq.'col_h2ovapor')) then
      if (name.eq.'rmsps') then
        a=a*ps_psgcm
      endif
      
!     Watercap value can only be 0 or 1
      if (name.eq.'water_cap') then 
       if(a.lt.0.5) then
        a = 0.
       else 
        a=1
       endif
      endif      

!     error handling (unused yet)
! 9999 a=0.
!      return
      end


!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine interpol(k,up_low,vtype,pseudoalt)

!     calculate the vertical interpolation between low and up atmosphere    
!     when data are not in both files (low and thermo)    

      use MCD_var, only : dimlat, dimlon, dimuti, dimlevs , low, up, var_3d, var_3d2, varrms3d, varrms3d2
      
      implicit none
      
!     inputs      
      integer,     intent(in) :: k,up_low
      character*4, intent(in) :: vtype
      real,        intent(in) :: pseudoalt(dimlevs)

!     local variables
      integer     startk,endk
      integer     iloop,kloop,jloop,it

      if (up_low.eq.up) then 
      startk=low+1
      endk=low+3
      else
      startk=low-2        
      endk=low
      endif

!     3D extrapolation for the first 3 layers of the thermosphere          
      if (vtype.eq.'mean') then
       do it=1,dimuti
        if (k.ne.10) then
         do kloop=startk,endk
           do jloop=1,dimlat
            do iloop=1,dimlon
            
              var_3d(iloop,jloop,kloop,it,k)=var_3d(iloop,jloop,startk-1,it,k)+(pseudoalt(kloop)-              & 
              pseudoalt(startk-1))*(var_3d(iloop,jloop,endk+1,it,k)-var_3d(iloop,jloop,startk-1,it,k))         &
              /(pseudoalt(endk+1)-pseudoalt(startk-1))
              
              var_3d2(iloop,jloop,kloop,it,k)=var_3d2(iloop,jloop,startk-1,it,k)+(pseudoalt(kloop)-            &
              pseudoalt(startk-1))*(var_3d2(iloop,jloop,endk+1,it,k)-var_3d2(iloop,jloop,startk-1,it,k))       &
              /(pseudoalt(endk+1)-pseudoalt(startk-1))
              
            enddo
           enddo
          enddo
      elseif(k.eq.10) then   ! "o" case
         do kloop=2,30      ! interpolation for the all low atmosphere
           do jloop=1,dimlat
            do iloop=1,dimlon
            
              var_3d(iloop,jloop,kloop,it,k)=exp(log(var_3d(iloop,jloop,1,it,k))+(pseudoalt(kloop)-pseudoalt(1))*           &
              (log(max(var_3d(iloop,jloop,31,it,k),1.E-30))-log(var_3d(iloop,jloop,1,it,k)))/(pseudoalt(31)-pseudoalt(1)))
              
              var_3d2(iloop,jloop,kloop,it,k)=exp(log(var_3d2(iloop,jloop,1,it,k))+(pseudoalt(kloop)-pseudoalt(1))*         &
              (log(max(var_3d2(iloop,jloop,31,it,k),1.E-30))-log(var_3d2(iloop,jloop,1,it,k)))/(pseudoalt(31)-pseudoalt(1)))
                          
            enddo !iloop
           enddo !jloop
          enddo !kloop
         endif! "o" case 
        enddo   
      elseif (vtype.eq.'rms') then
!    2D extrapolation for the first 3 layers of the thermosphere          
         do kloop=startk,endk
           do jloop=1,dimlat
            do iloop=1,dimlon
             
             varrms3d(iloop,jloop,kloop,k)=varrms3d(iloop,jloop,startk-1,k)+(pseudoalt(kloop)-pseudoalt(startk-1))*   & 
             (varrms3d(iloop,jloop,endk+1,k)-varrms3d(iloop,jloop,startk-1,k))/(pseudoalt(endk+1)-pseudoalt(startk-1))

             varrms3d2(iloop,jloop,kloop,k)=varrms3d2(iloop,jloop,startk-1,k)+(pseudoalt(kloop)-pseudoalt(startk-1))* & 
             (varrms3d2(iloop,jloop,endk+1,k)-varrms3d2(iloop,jloop,startk-1,k))/(pseudoalt(endk+1)-pseudoalt(startk-1))
            
            enddo
           enddo
          enddo
       endif !vtype
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine extrapol3d(vtype,k,up_low,pseudoalt)

!  extrapolate 3d data when not in the initial netcdf files 
!  call subroutine interpol 

      use netcdf
      
      use MCD_var, only : dimlat, dimlon, dimuti, dimlevs, nbvarup, nbvarlow, low, up, nbcom, out, output_messages, &
                          var_3d, var_3d2, varrms3d, varrms3d2
            
      implicit none
      
!     inputs      
      integer,     intent(in) :: k,up_low
      character*4, intent(in) :: vtype
      real,        intent(in) :: pseudoalt(dimlevs)

!     local variables      
      integer     iloop,kloop,jloop,it
      real        var_ini(nbvarup-nbcom)

!     initial values in low atmosphere ! not valid for MCDv5 !!!
!      var_ini(1)=0.2E-11!o : only for surface
!      var_ini(2)=95.32E-2 !co2
!      var_ini(3)=8.E-4 !co
!      var_ini(4)=0.027!n2

      if (up_low.eq.up) then !extrapolation in the thermosphere 

       if (vtype.eq.'mean') then
        do it=1,dimuti
         do kloop=low+4,dimlevs
           do jloop=1,dimlat
            do iloop=1,dimlon
                 var_3d(iloop,jloop,kloop,it,k)=0.
                 var_3d2(iloop,jloop,kloop,it,k)=0.
            enddo
           enddo
          enddo
         enddo

       elseif (vtype.eq.'stdv'.or.vtype.eq.'rms')    then 
         do kloop=low+4,dimlevs
          do jloop=1,dimlat
           do iloop=1,dimlon
             if (vtype.eq.'rms') then
                varrms3d(iloop,jloop,kloop,k)=0.
                varrms3d2(iloop,jloop,kloop,k)=0.
!             else if (vtype.eq.'stdv') then
!                varsd3d(iloop,jloop,kloop,k)=0.
!                varsd3d2(iloop,jloop,kloop,k)=0.
             endif
            enddo
           enddo
          enddo

       endif    

! extrapolation for the first 3 layers of the thermosphere          
! *********************************************************        
      call  interpol(k,up,vtype,pseudoalt)

      else  ! extrapolation in the lower atmosphere   

       if (vtype.eq.'mean') then
         do it=1,dimuti
          do kloop=1,low-3
           do jloop=1,dimlat
            do iloop=1,dimlon
               var_3d(iloop,jloop,kloop,it,k)=var_ini(k-nbvarlow)
               var_3d2(iloop,jloop,kloop,it,k)=var_ini(k-nbvarlow)
             enddo
            enddo
           enddo
           enddo

       elseif (vtype.eq.'stdv'.or.vtype.eq.'rms')    then 
         do kloop=1,low-3
           do jloop=1,dimlat
            do iloop=1,dimlon
              if (vtype.eq.'rms') then
               varrms3d(iloop,jloop,kloop,k)=0.
               varrms3d2(iloop,jloop,kloop,k)=0.
!              else if (vtype.eq.'stdv') then
!               varsd3d(iloop,jloop,kloop,k)=0.
!               varsd3d2(iloop,jloop,kloop,k)=0.
              endif
            enddo
           enddo
          enddo
        endif    

! extrapolation for the last 3 layers of the low atmosphere          
! *********************************************************        
       call  interpol(k,low,vtype,pseudoalt)
        
       endif! up_low          

      return
      end 

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine get_2d(nf,k,varname,order)

!  get_2d reads the 2d mean variables in low netcdf files.
!  Fills var_2d() and var_2d2() (defined in constants_mcd.inc)  

      use netcdf

      use MCD_var, only : dimlat, dimlon, dimuti, nbvar2d, out, output_messages, &
                          var_2d, var_2d2
      implicit none

!     inputs      
      integer,      intent(in) :: nf,k,order
      character*50, intent(in) :: varname

!     local variables     
      integer      ierr,iloop,jloop,it
      integer      var2didin(nbvar2d)
      real         temp2d(dimlon,dimlat,dimuti)

!     write(out,*),'varname(k) k',k,varname
!     NETCDF reading 2d mean variable      
         ierr=nf90_inq_varid(nf,varname,var2didin(k))
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GET_2D Error:"
             write(out,*) nf90_strerror(ierr), varname
           endif
           stop
         endif
         ierr = nf90_get_var(nf,var2didin(k),temp2d)
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GET_2D Error:"
             write(out,*) nf90_strerror(ierr)
           endif
           stop
         endif

         do it=1,dimuti
           do jloop=1,dimlat
            do iloop=1,dimlon
                  if (order.eq.1) then
                  var_2d(iloop,jloop,it,k)=temp2d(iloop,dimlat+1-jloop,it) 
                  elseif (order.eq.2) then 
                  var_2d2(iloop,jloop,it,k)=temp2d(iloop,dimlat+1-jloop,it) 
                  endif
            enddo
           enddo
          enddo

      return
      end 

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine get_3d(nf,k,varname,up_low,order)

!  getsd_3D reads the 3D mean variables in up or low netcdf files.
!  Fills var_3d() and var_3d2() (defined in constants_mcd.inc)  

      use netcdf

      use MCD_var, only : dimlat, dimlon, dimuti, dimlevs, low, up, nbvar3d, out, output_messages, &
                          var_3d, var_3d2
      
      implicit none

!     inputs      
      integer,      intent(in) :: nf,k,up_low,order
      character*50, intent(in) :: varname

!     local variables      
      integer      ierr,iloop,kloop,jloop,it
      integer      var3didin(nbvar3d)
      real         temp3dlow(dimlon,dimlat,low,dimuti)
      real         temp3dup(dimlon,dimlat,up,dimuti)

!     write(out,*),'varname(k) k',k,varname
      ierr=nf90_inq_varid(nf,varname,var3didin(k))
!         ierr=nf90_inq_varid(nf,varname,var3didin2(k))
      if(ierr.ne.nf90_noerr) then
        if (output_messages) then
          write(out,*) "GET_3D Error:"
          write(out,*) nf90_strerror(ierr),varname
        endif
        stop 
      endif
      if (up_low.eq.up) then
         ierr = nf90_get_var(nf,var3didin(k),temp3dup)
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GET_3D Error:"
             write(out,*) nf90_strerror(ierr)
           endif
           stop
         endif

         do it=1,dimuti
          do kloop=low+1,dimlevs
           do jloop=1,dimlat
            do iloop=1,dimlon
             if (order.eq.1) then
                  var_3d(iloop,jloop,kloop,it,k)=temp3dup(iloop,dimlat+1-jloop,kloop-low,it) 
             elseif(order.eq.2) then      
                  var_3d2(iloop,jloop,kloop,it,k)=temp3dup(iloop,dimlat+1-jloop,kloop-low,it) 
             endif
            enddo
           enddo
          enddo
         enddo 

      else    

        ierr = nf90_get_var(nf,var3didin(k),temp3dlow)
        if(ierr.ne.nf90_noerr) then
          if (output_messages) then
            write(out,*) "GET_3D Error:"
            write(out,*) nf90_strerror(ierr)
          endif
          stop
        endif

        do it=1,dimuti
         do kloop=1,low
          do jloop=1,dimlat
           do iloop=1,dimlon
            if (order.eq.1) then
                  var_3d(iloop,jloop,kloop,it,k)=temp3dlow(iloop,dimlat+1-jloop,kloop,it) 
            elseif(order.eq.2) then      
                  var_3d2(iloop,jloop,kloop,it,k)=temp3dlow(iloop,dimlat+1-jloop,kloop,it) 
            endif     
             enddo
            enddo
          enddo
         enddo

      endif ! of if (up_low.eq.up)

      return
      end 

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine getsd_2d(nf,vtype,k,varname,order)

!  getsd_2D reads the 2D RMS variables from netcdf files and
! fills corresponding varrms2d(k) and varrms2d2(k) arrays (which are defined
! as common in constants_mcd.inc)

      use netcdf

      use MCD_var, only : dimlat, dimlon, dimuti, nbsd2d, out, output_messages,   & 
                          varrms2d, varrms2d2

      implicit none

!     inputs      
      integer,      intent(in) ::  nf      ! Input NetCDF file ID
      character*4,  intent(in) ::  vtype
      integer,      intent(in) ::  k
      character*50, intent(in) ::  varname
      integer,      intent(in) ::  order

!     local variables      
      integer      ierr,iloop,jloop
      integer      sd2didin(nbsd2d)    ! to store ID # of variable
      real         temp2d(dimlon,dimlat,dimuti) ! to temporarely store variable

!      write(out,*),'varname(k) k',k,varname

!  Read variable from NetCDF file      
         ierr=nf90_inq_varid(nf,varname,sd2didin(k))
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GETSD_2D Error:"
             write(out,*) nf90_strerror(ierr),varname
           endif
           stop 
         endif
         ierr = nf90_get_var(nf,sd2didin(k),temp2d)
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GETSD_2D Error:"
             write(out,*) nf90_strerror(ierr) , 'stop in getsd3d'
           endif
           stop 
         endif

! Copy variable
           do jloop=1,dimlat
            do iloop=1,dimlon

             if (vtype.eq.'rms') then
                  if (order.eq.1) then
                  varrms2d(iloop,jloop,k)=temp2d(iloop,dimlat+1-jloop,1) 
                  elseif (order.eq.2) then
                  varrms2d2(iloop,jloop,k)=temp2d(iloop,dimlat+1-jloop,1)
                  endif 
             endif
                               
            enddo
           enddo

      return
      end 

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine getsd_3d(nf,vtype,k,varname,up_low,order)

! getsd_3D reads the 3D RMS and ARMS variables in up or low netcdf files 
! and fills corresponding varrms3d(k) and vararms3d(k) arrays (which are 
! defined as common in constants_mcd.inc)
      
      use netcdf

      use MCD_var, only : dimlat, dimlon, dimlevs, dimuti, low, up, nbsd3d, out, output_messages, &
                          varrms3d, varrms3d2, vararms3d, vararms3d2
      
      implicit none
          
!     inputs      
      integer,          intent(in) ::  nf      ! Input NetCDF file ID
      character(len=*), intent(in) ::  vtype
      integer,          intent(in) ::  k
      character(len=*), intent(in) ::  varname
      integer,          intent(in) ::  up_low
      integer,          intent(in) ::  order

!     local variables
      integer      iloop,kloop,jloop
      integer      ierr
      integer      sd3didin(nbsd3d+1)     ! to store ID # of variable
      real         temp3dlow(dimlon,dimlat,low,dimuti)
! temp3dlow(:,:,:,:) to temporarely store variable from "low" file
      real         temp3dup(dimlon,dimlat,up,dimuti)
! temp3dup(:,:,:,:) to temporarely store variable from "up" file

!      write(out,*)'getsd_3d: k varname',k,trim(varname)

!  Get ID of variable from NetCDF file      
         ierr=nf90_inq_varid(nf,varname,sd3didin(k))
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GETSD_3D Error:"
             write(out,*) nf90_strerror(ierr),varname
           endif
           stop 
         endif

      if (up_low.eq.up) then
      ! Read variable from "up" file
         ierr = nf90_get_var(nf,sd3didin(k),temp3dup)
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GETSD_3D Error:"
             write(out,*) nf90_strerror(ierr)
           endif
           stop
         endif

         ! Copy variable
          do kloop=low+1,dimlevs
           do jloop=1,dimlat
            do iloop=1,dimlon

             if (vtype.eq.'rms') then
                  if (order.eq.1) then
                    varrms3d(iloop,jloop,kloop,k)=temp3dup(iloop,dimlat+1-jloop,kloop-low,1) 
                  elseif (order.eq.2) then
                    varrms3d2(iloop,jloop,kloop,k)=temp3dup(iloop,dimlat+1-jloop,kloop-low,1) 
                  endif
             else if (vtype.eq.'arms') then
                  if (order.eq.1) then
                    vararms3d(iloop,jloop,kloop,k)=temp3dup(iloop,dimlat+1-jloop,kloop-low,1) 
                  elseif (order.eq.2) then
                    vararms3d2(iloop,jloop,kloop,k)=temp3dup(iloop,dimlat+1-jloop,kloop-low,1) 
                  endif
             endif
             
            enddo
           enddo
          enddo

      else ! Read variable from "low" file
         ierr = nf90_get_var(nf,sd3didin(k),temp3dlow)
         if(ierr.ne.nf90_noerr) then
           if (output_messages) then
             write(out,*) "GETSD_3D Error:"
             write(out,*) nf90_strerror(ierr)
           endif
           stop
         endif

         ! Copy variable (and permute latitude index)
          do kloop=1,low
           do jloop=1,dimlat
            do iloop=1,dimlon

             if (vtype.eq.'rms') then
                  if (order.eq.1) then
                  varrms3d(iloop,jloop,kloop,k)=temp3dlow(iloop,dimlat+1-jloop,kloop,1) 
                  elseif (order.eq.2) then
                  varrms3d2(iloop,jloop,kloop,k)=temp3dlow(iloop,dimlat+1-jloop,kloop,1) 
                  endif
             else if (vtype.eq.'arms') then
                  if (order.eq.1) then
                  vararms3d(iloop,jloop,kloop,k)=temp3dlow(iloop,dimlat+1-jloop,kloop,1) 
                  elseif (order.eq.2) then
                  vararms3d2(iloop,jloop,kloop,k)=temp3dlow(iloop,dimlat+1-jloop,kloop,1) 
                  endif
             endif
              
            enddo
           enddo
          enddo
       endif! of if (up_low.eq.up)         

      
      return
      end 

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine var3d(a,lon,lat,zsurface,levhi,levlow,levweight,pratio,sheight,  &  
                       p_pgcm,sigma,ps_psgcm,utime,name,ier,itimint,wl,wh)

!     Retrieve the value of 3-d variable=name at longitude=lon, latitude=lat
!     and Universal time=utime. The height (above local surface) of the
!     variable is given by zsurface, although only levhi, levlow and levweight
!     are needed for most vertical interpolations.
!     Bilinear interpolation (see called routine profi) is used to get user
!     specified longitude and latitude.
!     Linear interpolation of variables with height is done in the vertical
!     direction, exept for density (and similar fields), which is
!     interpolated linearly with pressure.
!     When below first atmospheric level, specific "interpolations" are used
!     for temperature and horizontal winds (Monin-Obukhov)
!     For this reason, var3d now needs sigma in input
!     

      use MCD_var, only : dimlevs, g0, a0, varname3d, nbvar3d, ma3d, out, output_messages, z_0

      implicit none

!     inputs
      real,             intent(in)  ::  lon              ! longitude (east) of point (deg.)
      real,             intent(in)  ::  lat              ! latitude of point (deg.)
      real,             intent(in)  ::  zsurface         ! altitude above surface of point (m)
      integer,          intent(in)  ::  levhi            ! database level upper bound
      integer,          intent(in)  ::  levlow           ! database level lower bound
      real,             intent(in)  ::  levweight(2)     ! level weight for vertical interpolation /(1) for linear in height (2) for linear in pressure
      real,             intent(in)  ::  pratio           ! ratio of pressure to extreme value if out of range
      real,             intent(in)  ::  sheight(dimlevs) ! altitude of GCM sigma levels
      real,             intent(in)  ::  p_pgcm(dimlevs)  ! high res to GCM pressure ratios
      real,             intent(in)  ::  sigma(dimlevs)   ! sigma levels in MCD grid
      real,             intent(in)  ::  ps_psgcm         ! High res to GCM surface pressure ratio 
      real,             intent(in)  ::  utime            ! Universal time (0. to 24. hrs)=local time at lon=0
      integer,          intent(in)  ::  itimint          ! seasonal interpolation flags
      real,             intent(in)  ::  wl,wh            ! seasonal interpolation weights 
      character(len=*), intent(in)  ::  name             ! Name of variable

!     outputs
      integer,          intent(out) ::  ier              ! error flag (0=OK, 1=NOK)
      real,             intent(out) ::  a                ! value of variable

!     local variables
      real    profile(dimlevs) ! profile in MCD grid 
      character*18 tmpname     ! Name of variable (for call to var2d)
      real    tsurf,ps ! surface temperature and surface pressure
      real    zu(dimlevs),zv(dimlevs) ! winds (used for temperature interpolation)
      real    hfmax,zmax,wstar_in ! pbl parameters from the thermals for interpolation
      real    pplev(dimlevs),ph(dimlevs) !level pressure and potential temp
      real    T_out,u_out,ustar,tstar,vvv,vhf ! outputs of pbl_parameters
      real    rcp ! ratio of r over cp
!      real    pz0 !surface roughness length interpolated at output location
      real    norm1 ! norm of velocity vector at first latitude level
      integer ierr
      real          vmr_gcm(dimlevs)  ! vmr at GCM levels
      real          rho_gcm(dimlevs)  ! density at GCM levels
      real          temp_gcm(dimlevs) ! temperature at GCM levels
      real          coef              ! coef accounting composition
      real          xratio,x,xi,xsum  ! coef for extrapolation
      integer       igas
      
      real          g     

      ! intermediate variables for the call to pbl_parameters
      real :: tmp_pplev(1,dimlevs),tmp_sheight(1,dimlevs)
      real :: tmp_zu(1,dimlevs),tmp_zv(1,dimlevs),tmp_ph(1,dimlevs)
      real :: tmp_T_out(1,1),tmp_u_out(1,1)
      real :: tmp_ustar(1),tmp_tstar(1),tmp_vhf(1),tmp_vvv(1)

      ! calls to 2D (and 3D) variables from pbl_parameter are handled in var3d to avoid needless complexity in var2d.
      if ((name.eq.'surfstress').or.(name.eq.'sensib_flux').or.(name.eq.'vvv').or.(name.eq.'vhf')) then
          goto 1000
      endif

      ier = 0

      ! get horizontally interpolated GCM vertical profile of variable 'name'
      call profi(profile,lon,lat,utime,name,ier,itimint,wl,wh,0,levlow,levhi)
      if (ier.ne.0) then
        if (output_messages) then
         write(out,*)'VAR3D Error : profile not available for variable',name
        endif
        ier=1
        goto 9999
      endif


      if ((name.eq.'rho').or.(name.eq.'rmsrho').or.(name.eq.'armsrho').or.(name.eq.'armspressure')) then
!     interpolate densities linearly in pressure
         a=profile(levlow)*p_pgcm(levlow)+levweight(2)*(profile(levhi)*p_pgcm(levhi)-profile(levlow)*p_pgcm(levlow))
!     correction for densities which are out of sigma range
!         a=pratio*a
         if(.not.(levlow.eq.levhi.and.levlow.eq.dimlevs)) then
          a=pratio*a   
         else    
          g = g0*(a0/(a0+sheight(dimlevs)))**2
          call profi(temp_gcm,lon,lat,utime,'temp',ierr,itimint,wl,wh,0,dimlevs,dimlevs)  
     
          ! New in MCD6.1, to correct extrapolation of rho,rms_rho        
          call profi(rho_gcm,lon,lat,utime,'rho',ierr,itimint,wl,wh,0,dimlevs,dimlevs)    
                              
          tmpname = 'ps'
          call var2d(ps,lon,lat,utime,tmpname,ierr,itimint,wl,wh,ps_psgcm)
          xratio = 0.0
          do igas=1,nbvar3d
           if(ma3d(igas).lt.0) cycle   
           call profi(vmr_gcm,lon,lat,utime,varname3d(igas),ierr,itimint,wl,wh,0,dimlevs,dimlevs)
     

           coef = ma3d(igas)*sigma(dimlevs)*ps/(8314.4598*temp_gcm(dimlevs)*rho_gcm(dimlevs)) 
     
!           coef = ma3d(igas)*sigma(dimlevs)*ps/
!     &          (8314.4598*temp_gcm(dimlevs)*a)  ! a is rho or pressure
     
     
           if(name.eq.'armspressure') coef = 1.0
!           xratio = xratio+coef*vmr_gcm(dimlevs)*
!     &              exp((sheight(dimlevs)-zsurface)*g/
!     &              (8314.4598/ma3d(igas)*temp_gcm(dimlevs)))
!           
           xratio = xratio+coef*vmr_gcm(dimlevs)*exp(-(a0+sheight(dimlevs))*(zsurface-sheight(dimlevs)) & 
                    /(a0+zsurface)*g/(8314.4598/ma3d(igas)*temp_gcm(dimlevs)))           
          enddo
          a=xratio*a
         endif ! of if(.not.(levlow.eq.levhi.and.levlow.eq.dimlevs))
      elseif ((name.eq.'vmr_h2ovapor').or.(name.eq.'vmr_co2').or.(name.eq.'vmr_co').or.(name.eq.'vmr_n2') & 
          .or.(name.eq.'vmr_ar').or.(name.eq.'vmr_o').or.(name.eq.'vmr_o2').or.(name.eq.'vmr_o3')         &
          .or.(name.eq.'vmr_he').or.(name.eq.'vmr_h').or.(name.eq.'vmr_h2')) then
        ! Default linear interpolation between levels:
         a=profile(levlow)+(profile(levhi)-profile(levlow))*levweight(1)
        ! If abowe last atmospheric level
         if ((levlow.eq.levhi).and.(levlow.eq.dimlevs)) then
          g = g0*(a0/(a0+sheight(dimlevs)))**2
          call profi(temp_gcm,lon,lat,utime,'temp',ierr,itimint,wl,wh,0,dimlevs,dimlevs)
          xsum = 0.0
          do igas=1,nbvar3d
           if(ma3d(igas).lt.0) cycle   
           call profi(vmr_gcm,lon,lat,utime,varname3d(igas),ierr,itimint,wl,wh,0,dimlevs,dimlevs)
!           x = vmr_gcm(dimlevs)*
!     &              exp((sheight(dimlevs)-zsurface)*g/
!     &              (8314.4598/ma3d(igas)*temp_gcm(dimlevs)))
!
           x = vmr_gcm(dimlevs)*exp(-(a0+sheight(dimlevs))*(zsurface-sheight(dimlevs))                     & 
               /(a0+zsurface)*g/(8314.4598/ma3d(igas)*temp_gcm(dimlevs)))
           
           if(name.eq.varname3d(igas)) xi = x
           xsum = xsum + x
          enddo            
          a = xi/xsum             
         endif ! of if ((levlow.eq.levhi).and.(levlow.eq.dimlevs))
      elseif ((name.eq.'temp')) then
        ! Default linear interpolation between levels:
        a=profile(levlow)+(profile(levhi)-profile(levlow))*levweight(1)
        ! If below first atmospheric level, use linear
        ! interpolation with surface temperature
        if ((levlow.eq.levhi).and.(levlow.eq.1)) then
           goto 1000
        endif ! of if ((levlow.eq.levhi).and.(levlow.eq.1))
      elseif ((name.eq.'u').or.(name.eq.'v')) then
        ! Default linear interpolation between levels:
        a=profile(levlow)+(profile(levhi)-profile(levlow))*levweight(1)
        ! If below first atmopheric level, mimic log boundary layer
        ! with roughness length z_0; below z_0, set wind velocity to zero
        if ((levlow.eq.levhi).and.(levlow.eq.1)) then
           goto 1000
        endif
      elseif ((name.eq.'vvv').or.(name.eq.'vhf')) then
           goto 1000
      else ! most variables are interpolated linearly in height
        a=profile(levlow)+(profile(levhi)-profile(levlow))*levweight(1)
      endif
!

! ---------------------------------------------------------------------
! Special case : Monin Obukhov interpolation
! for variables : u,v, theta below z1, vhf, vvv, surfstress, sensibflux
!----------------------------------------------------------------------

      return

1000  continue
          ! get surface temperature at same location
          ! in the PBL, rcp is constant
          rcp = 0.2567930
          tmpname="tsurf"
          call var2d(tsurf,lon,lat,utime,tmpname,ierr,itimint,wl,wh,ps_psgcm)
          ! get surface pressure at same location
          tmpname="ps"
          call var2d(ps,lon,lat,utime,tmpname,ierr,itimint,wl,wh,ps_psgcm)
          ! get wind profile at same location
          tmpname="u"
          call profi(zu,lon,lat,utime,tmpname,ierr,itimint,wl,wh,0,0,0)
          tmpname="v"
          call profi(zv,lon,lat,utime,tmpname,ierr,itimint,wl,wh,0,0,0)
          ! get thermals parameters at same location
          tmpname="zmax"
          call var2d(zmax,lon,lat,utime,tmpname,ierr,itimint,wl,wh,ps_psgcm)
          tmpname="hfmax"
          call var2d(hfmax,lon,lat,utime,tmpname,ierr,itimint,wl,wh,ps_psgcm)
          tmpname="wstar"
          call var2d(wstar_in,lon,lat,utime,tmpname,ierr,itimint,wl,wh,ps_psgcm)
          ! get temp profile at same location
          tmpname="temp"
          call profi(profile,lon,lat,utime,tmpname,ier,itimint,wl,wh,0,0,0)
          ! compute pressure profile at same location
          pplev(:) = sigma(:)*ps
          ! compute corresponding potential temperature profile
          ph(:) = profile(:)*((ps/pplev(:))**rcp)
          ! copy some variables to intermediate arrays of correct size
          tmp_pplev(1,1:dimlevs)=pplev(1:dimlevs)
          tmp_sheight(1,1:dimlevs)=sheight(1:dimlevs)
          tmp_zu(1,1:dimlevs)=zu(1:dimlevs)
          tmp_zv(1,1:dimlevs)=zv(1:dimlevs)
          tmp_ph(1,1:dimlevs)=ph(1:dimlevs)
          ! interpolate
          call pbl_parameters(1,dimlevs,(/ps/),tmp_pplev,(/z_0/),tmp_sheight,tmp_zu,tmp_zv,    & 
                              (/wstar_in/),(/hfmax/),(/zmax/),(/tsurf/),tmp_ph,(/zsurface/),1, &
                              tmp_T_out,tmp_u_out,tmp_ustar,tmp_tstar,tmp_vhf,tmp_vvv)
          ! copy some intermediate output arrays to correct ones
          T_out=tmp_T_out(1,1)
          u_out=tmp_u_out(1,1)
          ustar=tmp_ustar(1)
          tstar=tmp_tstar(1)
          vhf=tmp_vhf(1)
          vvv=tmp_vvv(1)

      if (name.eq.'vvv') then
          a=vvv
      elseif (name.eq. 'vhf') then
          a=vhf
      elseif ((name.eq.'u').or.(name.eq.'v')) then
          ! N.B: u_out is the norm of the velocity vector
          norm1=sqrt(zu(1)*zu(1)+zv(1)*zv(1)) ! norm of velocity at atm level 1
          if (norm1.eq.0) then
            ! should almost never happen, but just in case...
            a=0
          else
            if (u_out.gt.norm1) then
              ! should never be the case, but might, because of roundoff
              ! effects, when norm1 is very near (but not exactly) zero
              u_out=norm1
            endif
            if (name.eq.'u') then
              a=zu(1)*(u_out/norm1)
            else
              a=zv(1)*(u_out/norm1)
            endif
          endif ! of if (norm1.eq.0)
      elseif (name.eq.'temp') then
          a=T_out
      elseif (name.eq.'surfstress') then
          tmpname="rho" 
          call profi(profile,lon,lat,utime,tmpname,ier,itimint,wl,wh,0,1,1)
          a= profile(1)*p_pgcm(1)*ustar*ustar
      elseif (name.eq.'sensib_flux') then
          ! at surface, cp is constant == 744.499
          tmpname="rho"
          call profi(profile,lon,lat,utime,tmpname,ier,itimint,wl,wh,0,1,1)
          a= profile(1)*p_pgcm(1)*744.499*ustar*tstar
      endif

      return

!     Error handling
 9999 a=0.
      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine max2d(a,lon,lat,name,ier,itimint,wl,wh)

!     Retrieve the daily maximum value of 2-d variable=name at 
!     longitude=lon, latitude=lat

      use MCD_var, only : out, output_messages

      implicit none

!     inputs
      real,         intent(in)  ::  lon      ! west longitude of point
      real,         intent(in)  ::  lat      ! latitude of point
      character*18, intent(in)  ::  name     ! Name of variable
      integer,      intent(in)  ::  itimint  ! seasonal interpolation flag 
      real,         intent(in)  ::  wl,wh    ! seasonal interpolation weightings

!     outputs
      integer,      intent(out) ::  ier      ! Error flag (0=OK, 1=NOK)
      real,         intent(out) ::  a        ! maximum of variable

!     local variables
      integer      i
      real         x
      real         xmax
      real         utime
      
      ier=0
      xmax=-1.e20
      do i=0,22,2
        utime=float(i)
        call var2d(x,lon,lat,utime,name,ier,itimint,wl,wh,1.0)
        if(ier.ne.0) then
           ier=1
           if (output_messages) then
             write(out,*)"MAX2D Error : impossible to find ",name," maximum"
           endif
           goto 9999
        endif
        if (x.gt.xmax) xmax=x
      enddo
      a=xmax

      return

!     Error handling
 9999 a=0.
      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine min2d(a,lon,lat,name,ier,itimint,wl,wh)

!     Retrieve the daily minimum value of 2-d variable=name at 
!     longitude=lon, latitude=lat

      use MCD_var, only : out, output_messages

      implicit none


!     inputs
      real,         intent(in)  ::  lon     ! longitude of point
      real,         intent(in)  ::  lat     ! latitude of point
      character*18, intent(in)  ::  name    ! Name of variable
      real,         intent(in)  ::  wl,wh   ! seasonal interpolation weightings
      integer,      intent(in)  ::  itimint ! seasonal interpolation flag

!     output
      integer,      intent(out) ::  ier     ! Error flag (0=OK, 1=NOK)
      real,         intent(out) ::  a       ! minimum of variable


!     local variables
      integer      i
      real         x
      real         xmin
      real         utime

      ier=0
      xmin=1.e20
      do i=0,22,2
        utime=float(i)
        call var2d(x,lon,lat,utime,name,ier,itimint,wl,wh,1.0)
        if(ier.ne.0) then
           ier=1
           if (output_messages) then
             write(out,*)"MIN2D Error : impossible to find ",name," minimum"
           endif
           goto 9999
        endif
        if (x.lt.xmin) xmin=x
      enddo
      a=xmin
      return

!     Error handling
 9999 a=0.
      return
      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      function ran1(idum)
!     "Minimal" random number generator of Park and Miller with Bays-Durham
!     shuffle and added safeguards 
!     Return a uniform random deviate between 0.0 and 1.0 (exclusive of the
!     endpoints values). Call with idum a negative integer to initialize;
!     thereafter, do not alter idum between successive deviates in a sequence.
!     RNMX should approximate the largest floating value that is less than 1.

      implicit none

! input:
      integer  idum    ! Seed for random number generator (if negative)
                       ! the value of idum is altered by the function

! returned value:
      real ran1

! local variables:
      integer IA,IM,IQ,IR,NTAB,NDIV
      real AM,EPS,RNMX
      parameter (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      integer j,k
      integer iv(NTAB),iy
      save iv,iy
      data iv /NTAB*0/, iy /0/

      if ((idum.le.0).or.(iy.eq.0)) then
         idum=max(-idum,1)
         do j=NTAB+8,1,-1
            k=idum/IQ
            idum=IA*(idum-k*IQ)-IR*k
            if (idum.lt.0) idum=idum+IM
            if (j.le.NTAB) iv(j)=idum
         end do
         iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)

      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

!      subroutine dustmix(scena,lat,Ls,dod,psurf,p,dust_mmr)
!     EM 2012: not needed for MCDv5
!     Subroutine used to reconstruct the dust mixing ratio 
!     assumed in the GCM run, at a given pressure level. 
!     F. Forget 2005

!      implicit none

!      include "constants_mcd.inc"

!     INPUT
!      integer scena  ! scenario
!      real lat  ! latitude  (degree) 
!      real Ls       ! solar longitude (deg)
!      real dod      ! dust optical depth
!      real psurf      ! surface pressure (Pa)
!      real p        ! local pressure (Pa)
!     OUTPUT
!      real dust_mmr  ! dust mass mixing ratio (kg/kg)
!     Local Variable
!      real radius, Qext, rho_dust
!      real zlsconst, topdust,topdust0,qextrhor,g
!      real zp, expfactor, xlat
!      logical firstcall
!      data firstcall /.true./
!      save firstcall,qextrhor,g
!      real pi
!      parameter   (pi=3.14159265359)


!      topdust=0. ! dummy initialization to get rid of compiler warnings

!     initialisation
!     --------------
!      if (firstcall) then
!         radius=1.8e-6  ! effective radius of dust (m)
!         Qext=3.  ! dust visible single scattering extinction coeff.
!         rho_dust=2500.  ! Mars dust density (kg.m-3)
!         qextrhor= (3./4.)*Qext/(rho_dust*radius)
!         g=3.72
!         firstcall = .false. 
!      end if
!      xlat = lat*pi/180.

!     Altitude of the top of the dust layer
!     -------------------------------------

!      zlsconst=SIN(ls*pi/180. - 2.76)
      ! TEMPORARILY REMOVE TESTS BELOW; MAKE NO SENSE WITH NEW DUST SCENARIOS
!      if (scena.eq.8) then
!             topdust= 30.        ! constant dust layer top = 30 km
!      else if (scena.eq.7) then      ! "Viking" scenario
!            topdust0=60. -22.*SIN(xlat)**2
!            topdust=topdust0+18.*zlsconst
!      else if(scena.le.6) then         !"MGS" scenario (MY24, storm)
!            topdust=60.+18.*zlsconst
!     &               -(32+18*zlsconst)*sin(xlat)**4
!     &               - 8*zlsconst*(sin(xlat))**5
!
!      else
!      topdust=70.
!      if (scena.gt.10) then
!        if (output_messages) then
!          write(out,*) "DUST_MMR error: problem with scena"
!        endif
!        stop 
!      endif

!     Computing dust mass mixing ratio
!     --------------------------------
!      if(p.gt.700./(988.**(topdust/70.))) then
!           zp=(700./p)**(70./topdust)
!           expfactor=max(exp(0.007*(1.-max(zp,1.))),1.E-10)
!      else
!           expfactor=1.E-10
!      endif
!     qextrhor is  (3/4)*Qext/(rho*reff)
!      dust_mmr = expfactor* dod * g / (psurf * qextrhor)
!      return
!      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine dust_deposition(ps,temp,rho,mmr,reff,dep)

      use MCD_var, only : g0
      
      implicit none
      
      real,intent(in)  :: ps ! surface pressure
      real,intent(in)  :: temp ! atm. temperature in first layer
      real,intent(in)  :: rho ! atm. density in first layer
      real,intent(in)  :: mmr ! dust mass mixing ratio
      real,intent(in)  :: reff ! dust effective radius
      
      
      real,intent(out) :: dep ! dust deposition on flat surface kg / m2 / s
      
      ! local variables
      logical,save :: firstcall=.true.
      real,save :: a,b,xnu,nueff
      real :: r_sed
      real :: vstokes
      ! physical constants:
      real,parameter :: visc=1.e-5 ! Molecular viscosity of CO2 gas (N.s.m-2)
      real,parameter :: molrad=2.2e-10 ! effective CO2 gas molecular radius (m)
      real,parameter :: rhodust=2500. ! Mars dust density (kg.m-3)
      
      IF (firstcall) THEN

!       Preliminary calculations for sedimentation velocity :
!       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!       Constant to compute stokes speed simple formulae
!       (Vstokes =  b * rho* r**2   with   b= (2/9) * rho * g0 / visc
         b = 2./9. * g0 / visc

!       - Constant  to compute gas mean free path
!        l= (T/P)*a, with a = (  0.707*8.31/(4*pi*molrad**2 * avogadro))
         a = 0.707*8.31/(4*3.1416* molrad**2  * 6.023e23)

!       - Correction to account for non-spherical shape (Murphy et al.  1990)
!   (correction = 0.85 for irregular particles, 0.5 for disk shaped particles)
         a = a  * 0.5

!       Correction to compute "sedimentation" effective radius r_sed 
!       from effective radius reff with the lognormal distribution
!       (r_sed = xnu * reff)
        nueff= 0.5   ! dust size distribution effective variance in GCM runs 
        xnu =  (1 + nueff)**2

      ENDIF ! of IF (firstcall)
      
      ! compute dust deposition on flat surface
      r_sed=xnu*reff
      vstokes = b * rhodust * r_sed**2 *(1 + 1.333* ( a*temp/ps )/r_sed)
      dep = mmr * rho * vstokes
      
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine air_properties(T,vmr_co2,vmr_n2,vmr_ar,vmr_o,vmr_co,Cp,gamma,viscosity,Rgas)

      implicit none
                                                                                
!     Subroutine used to compute some useful gas properties
!     from the climate database data
!     F. Forget 2005 / E. Millour 2012
                                                                                
!     INPUT
      real,intent(in) ::  T                                   ! temperature   (K)     
      real,intent(in) ::  vmr_co2,vmr_n2,vmr_ar,vmr_o,vmr_co  ! gas volume mixing ratios (mol/mol)
      
!     OUTPUT
      real,intent(out) :: cp          ! Heat capacity at constant pressure (J kg-1? K-1)
      real,intent(out) :: gamma       ! Cp/Cv Ratio of specific heats 
      real,intent(out) :: viscosity   ! air viscosity (N s m-2)
      real,intent(out) :: Rgas        ! gas constant  (J kg-1 K-1)
      
!     Local Variable
!     --------------

!      real vmr_ar   ! Argon vmr
!     Molecular heat capacity (J mol-1 K-1)
      real Cp_co2, Cp_co, Cp_n2, Cp_ar, Cp_O
!     Coefficient to compute conductivity = A*T**0.69  (W m-1 K-1)
!      real A_co2, A_co, A_n2, A_ar, A_O
!     Molecular mass
      real M_co2, M_co, M_n2, M_ar, M_O
!      real conduct,
      real meanmolmass,svmr
      logical firstcall
      data firstcall /.true./
      save firstcall
    
      save Cp_co2, Cp_co, Cp_n2, Cp_ar, Cp_O
!      save A_co2, A_co, A_n2, A_ar, A_O
      save M_co2, M_co, M_n2, M_ar, M_O

      integer i,j
      real,save :: M(5)
      real,save :: Phi(5,5)
      real :: nu(5),mfrac(5)
      real denom

!     initialisation
!     --------------
      if (firstcall) then
!           Molecular mass (kg mol-1)
            M_co2=44.01e-3
            M_co=28.01e-3
            M_n2=28.013e-3
            M_Ar=39.95e-3
            M_o=16.e-3
!           Molecular heat capacity (J mol-1 K-1)
            Cp_co2 = 37.
            Cp_co  = 29
            Cp_n2 = 29
            Cp_ar = 20
            Cp_o = 21
!           Coeff for conductivity :
!            A_co2=3.07e-4
!            A_o=7.6e-4
!            A_n2=5.6e-4
!            A_co=4.87e-4
!            A_ar=3.4e-4
! Build coefficients for viscosity: 1: CO2, 2: CO, 3: N2, 4: Ar, 5: O
             ! molar masses
             M(1)=44 ; M(2)=28 ; M(3)=28 ; M(4)=39.95 ; M(5)=16
             !Phi(i,j) coefficients:
             do i=1,5
               do j=1,5
                 phi(i,j)=sqrt(M(j)/M(i))
               enddo
             enddo

            firstcall=.false.
      end if

!     Estimating Argon mixing ratio ! Not for MCDv5 where vmr_ar is known
!     -----------------------------   
!      vmr_ar = 0.6 *vmr_n2

! 03/2011: improvement, use S. Lebonnois' formulation for Cp(T) for CO2
      Cp_co2=1.e3*M_co2*(T/460.)**0.35

!     Mean Molecular mass
!     ------------------
      Svmr = vmr_co2+vmr_n2+vmr_o+vmr_co+vmr_ar
      meanmolmass= (M_co2*vmr_co2+M_n2*vmr_n2+M_o*vmr_o+ M_co*vmr_co+M_ar*vmr_ar)/Svmr
      Rgas = 8.3144/meanmolmass

!     Computing Cp (Neglecting H2 => not valid if very high)
!     ------------
      Cp = (Cp_co2*vmr_co2+Cp_n2*vmr_n2+Cp_o*vmr_o+Cp_co*vmr_co+Cp_ar*vmr_ar)/Svmr


!     Conversion from J mol-1 K-1 to J kg-1 K-1
      Cp= Cp / meanmolmass

!     Computing gamma
      gamma = 1./(1-Rgas/Cp)

!     Computing viscosity
!     -------------------
!     Therma molecular Conductivity (W m-1 K-1)
!      conduct = (A_co2*vmr_co2+A_n2*vmr_n2+A_o*vmr_o
!     &        + A_co*vmr_co + A_ar*vmr_ar)/Svmr
!      conduct=T**0.69 * conduct
!      viscosity = conduct / (0.25*(4*Cp + 5*Rgas))  
  
! 03/2011: use (temperature dependent) viscosity of gases
      ! CO2: Sutherland formula
      nu(1)=1.572e-6*(T**1.5)/(T+240.)
      ! CO: Sutherland formula
      nu(2)=1.428e-6*(T**1.5)/(T+118.)
      ! N2: Sutherland formula
      nu(3)=1.407e-6*(T**1.5)/(T+111.)
      ! Ar: Van Itterbeek & Van Paemel, Physica V,no 10, 1938
      nu(4)=7.592e-6*(T/90.)**0.883
      ! O: Dalgarno & Smith Planet. Space Sci., Vol 9, pp. 1-2, 1962
      nu(5)=3.34e-7*(T)**0.71
      ! 
      mfrac(1)=vmr_co2
      mfrac(2)=vmr_co
      mfrac(3)=vmr_n2
      mfrac(4)=vmr_ar
      mfrac(5)=vmr_o
      
      viscosity=0
      do i=1,5
       denom=0
       do j=1,5
         denom=denom+mfrac(j)*phi(i,j)
       enddo
       viscosity=viscosity+(mfrac(i)*nu(i))/denom
      enddo
      
      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine build_sigma_hr(sigma_gcm,ps_gcm,ps_hr,sigma_hr,p_pgcm)

      use MCD_var, only : dimlevs
      
      implicit none

!     inputs
      real, intent(in)  :: sigma_gcm(dimlevs) ! GCM sigma levels
      real, intent(in)  :: ps_gcm             ! GCM surface pressure
      real, intent(in)  :: ps_hr              ! High res surface pressure
!     outputs
      real, intent(out) :: sigma_hr(dimlevs)  ! High res sigma levels
      real, intent(out) :: p_pgcm(dimlevs)    ! high res to GCM pressure ratios
      
!     local variables
      integer l
      real x  ! lower layer compression (-0.9<x<0) or dilatation (0.<x<0.9)
      real rp     ! surface pressure ratio ps_hr/ps_gcm
      real deltaz   ! corresponding pseudo-altitude difference (km)
      double precision f  ! coefficient f= p_hr / p_gcm
      double precision z  ! altitude of transition of p_hr toward p_gcm (km)

! 1. Coefficients
      rp=ps_hr/ps_gcm
      deltaz=-10.*log(rp)
      x = min(max(0.12*(abs(deltaz)-1.),0.),0.8)
      if(deltaz.gt.0) x=-x
      z=max(deltaz + 3.,3.)

      do l=1,dimlevs
        f=rp*sigma_gcm(l)**x
!        f=f+(1-f)*0.5*(1+tanh(6.*(-10.*log(sigma_gcm(l))-z)/z))
!        sigma_hr(l)=f*sigma_gcm(l)/rp
        p_pgcm(l)=f+(1.d0-f)*0.5d0*(1.d0+tanh(6.d0*(-10.d0*log(dble(sigma_gcm(l)))-z)/z))
        sigma_hr(l)=p_pgcm(l)*sigma_gcm(l)/rp
      enddo

      end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine pres0(dset,dust,lat,lon,solar,utime,ps_MCD,oro_MCD,wl,wh,pres,alt,ierr)

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! Purpose:
! =======
!  Pres0 si a subroutine designed to yield high resolution MOLA topography
!  and recompute surface pressure accordingly. 
!  It uses:
!     1) Reference pressure measurements at Viking Lander 1 site (file VL1.ls)
!     2) High resolution MOLA topography (file mola32.nc)
!     3) Data from the Mars Climate Database
!
! Built from the v4.1 pres0 tool + improvements
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


      use MCD_var, only : dimlevs

      implicit none


! inputs:
      character*(*), intent(in)  :: dset    ! Path to MCD datafiles 
      integer,       intent(in)  :: dust    ! dust scenario
      real,          intent(in)  :: lon     ! Longitude coordinate of the point (East degrees)
      real,          intent(in)  :: lat     ! Latitude coordinate of the point (North degrees)
      real,          intent(in)  :: solar   ! Solar longitude (degrees)
      real,          intent(in)  :: utime   ! Universal time (hours) (time at lon=0)
      real,          intent(in)  :: ps_MCD  ! surface pressure (from MCD)
      real,          intent(in)  :: oro_MCD ! orography from MCD
      real,          intent(in)  :: wl,wh   ! season-wise interpolation weights

! outputs:
      real,          intent(out) :: pres    ! high resolution surface pressure (Pa)
      real,          intent(out) :: alt     ! surface altitude from MOLA (m)
      integer,       intent(out) :: ierr    ! Control variable

! local variables:
      real factcor  ! Pressure correction factor
      real zlon     ! East longitude (deg.) [0:360]
      real H        ! Scale height (m)
      real temp     ! Temperature at altitude ~1km

      character*18 name    !Name of variable to retrieve from MCD
      integer ier
      real profile(dimlevs) ! to temporarily store temperature profile
      integer ref_alt ! reference altitude index for temperature retrieval
      parameter (ref_alt=7) ! 7th level is ~ 1km above surface
      
! Ensure that (local) longitude zlon is in [0:360]
! since given "lon" is in [-180:180]

      zlon=lon
      if(zlon.lt.0.) zlon =zlon + 360.


      ierr=0

! 1. Read MOLA orography
      call mola(dset,lat,zlon,alt,ierr)
      if (ierr.ne.0) return

! 2. Compute a correction factor using VL1 pressure
      call calc_factcor(dset,dust,solar,wl,wh,factcor,ierr)
      if (ierr.ne.0) return

! 3. Get MCD temperature (at ~1km above surface)
      name='temp'
      call profi(profile,lon,lat,utime,name,ier,1,wl,wh,0,ref_alt,ref_alt)
      ! keep temperature of ref_alt layer (~1km)
        temp=profile(ref_alt)
      ! Ehouarn test:

! 4. Build Scale height H=R.T/g
! Gas Constant: R (m2.s-2.K-1) = 191
! surface gravity: g (m.s-2) = 3.73
      H=191*temp/3.73

! 5. Compute topography-corrected surface pressure
      pres=ps_MCD*factcor*exp(-(alt-oro_MCD)/H)

      end
 

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine calc_factcor(dset,dust,solar,wl,wh,factcor,ierr)
! Calculate a correction factor between Insight surface pressure data
! and MCD output at the same point
!       Corresponding altitude was computed using bilinear interpolation of
!       MOLA 32 topography data (and using areoid computed from the mgm1025
!       spherical harmonics coefficients) 
!     MCD5.3 :In case of dust storm scenario, use VL3 input 
!     MCD6.1 :Insight is used also for storm scenario

      use MCD_var, only : dimlevs

      implicit none

! Arguments:

!     inputs:
      character*(*), intent(in)  :: dset    ! path to MCD datafiles
      integer,       intent(in)  :: dust    ! dust scenario
      real,          intent(in)  :: solar   ! Solar longitude (degrees)
      real,          intent(in)  :: wl,wh   ! weights for interpolation

!     outputs:
      real,          intent(out) :: factcor ! correction factor
      integer,       intent(out) :: ierr    ! status ierr=0 if everything OK

! Local variables
      ! Insight coordinates
         
      real ins_lat, ins_lon, ins_alt
      parameter(ins_lat=4.50238,ins_lon=135.62345+360.,ins_alt=-2614.)
      
      real :: obs_lat, obs_lon, obs_alt
      real obs_MCD_oro ! MCD orography at Insight or VL3 coordinates
      real prescalc(12) ! surface pressure at Insight site, at times 2,4,...24 hours
      real tempcalc(12) ! temperature above insight, at times 2,4,...24 hours
      integer ref_alt ! reference altitude index for temperature retrieval
      parameter (ref_alt=7)
      real H        ! scale height
      real presmean ! mean value (over a day) of surface pressure
      real presins
      integer iloop
      integer obs_ind ! index for obs_tab() column to use; 2:Insight or 3:VL3

      character*18 name    ! Name of variable to retrieve from MCD
      integer ier
      real profile(dimlevs) ! to temporarily store temperature profile
      real, parameter :: a0 = 721.515442
      real, parameter :: a1 = 36.9922104
      real, parameter :: b1 = -33.9986763
      real, parameter :: a2 = -34.5741386 
      real, parameter :: b2 = 36.7709846
      real, parameter :: a3 = -0.631179631
      real, parameter :: b3 = -0.638219357
      real, parameter :: a4 = -0.328146309
      real, parameter :: b4 = -3.65572619
            
      real, parameter :: degtorad = acos(-1.)/180.
      

! 1. Read surface pressure and temperature (1km above surface) from MCD, 
!    at Insight site, at universal times (of day) 2, 4, ... 24 hours.

        obs_lat=ins_lat
        obs_lon=ins_lon
        obs_alt=ins_alt
        obs_ind=2 ! index for obs_tab() column to use

! 1.1 Read pressure and temperature from MCD at utime 2, 4, ... 24
      do iloop=1,12
        name='ps'
        ! N.B. vard2d expects longitudes in [-180:180]
        call var2d(prescalc(iloop),obs_lon-360.,obs_lat,real(2*iloop),name,ier,1,wl,wh,1.0)
        ! retrieve temperature profile
        name='temp'
        call profi(profile,obs_lon-360.,obs_lat,2.0*iloop,name,ier,1,wl,wh,0,ref_alt,ref_alt)
        ! keep temperature of ref_alt layer (~1km)
        tempcalc(iloop)=profile(ref_alt)
!        write(out,*)'CALC_FACTCOR: i=',iloop,
!     &            ' prescalc(i)=',prescalc(iloop),
!     &            ' tempcalc(i)=',tempcalc(iloop)
      enddo  

! 1.2 Get MCD orography corresponding to Insight site
      name='orography'
      call var2d(obs_MCD_oro,obs_lon-360.,obs_lat,0.0,name,ier,1,wl,wh,1.0)
!      write(out,*) 'CALC_FACTCOR: obs_MCD_oro=',obs_MCD_oro


! 2. Compute the correction factor due to difference between orocalc
!    and Insight altitude

      do iloop=1,12
! Gas Constant: R (m2.s-2.K-1) = 191
! surface gravity: g (m.s-2) = 3.73
         H=191*tempcalc(iloop)/3.73
         prescalc(iloop)=prescalc(iloop)*exp(-(obs_alt-obs_MCD_oro)/H)
      enddo

! 3. Compute average (over the day) pressure
      presmean=0.
      do iloop=1,12
         presmean = presmean + prescalc(iloop)/12.
      enddo
!      write(out,*)'CALC_FACTCOR: presmean=',presmean


! 4. Calculate reference surface pressure at Insight site using harmonics fit

     presins=a0+a1*cos(1*solar*degtorad)+b1*sin(1*solar*degtorad)+a2*cos(2*solar*degtorad)+b2*sin(2*solar*degtorad)+ & 
                a3*cos(3*solar*degtorad)+b3*sin(3*solar*degtorad)+a4*cos(4*solar*degtorad)+b4*sin(4*solar*degtorad)
!      write(out,*)'CALC_FACTCOR: presins=',presins

! 5. Compute the pressure correction factor
      factcor=presins/presmean

      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine nearsurfacenoise(ps,ps_noise_dev,ps_noise,temp_gcm_noise_dev,temp_gcm_noise,sheight)
      
! Routine to build perturbations (noise) for surface pressure and
! atmospheric temperatures near the surface. The amplitudes and
! range over which these perturbations are computed are hard coded
! in the routine (see below). E.M. 03/2009.
      
      use MCD_var, only : dimlevs
      
      implicit none

! arguments -inputs-:
      real, intent(in)  :: ps                      ! surface pressure
      real, intent(in)  :: ps_noise_dev            ! gaussian deviate (of unit standard deviation)
      real, intent(in)  :: temp_gcm_noise_dev      ! gaussian deviate 
      real, intent(in)  :: sheight(dimlevs)        ! altitude of layers
!     real, intent(in)  :: temp_gcm(dimlevs)       ! atmospheric temperatures

! arguments -outputs-:
      real, intent(out) :: ps_noise                ! perturbation to add to surface pressure
      real, intent(out) :: temp_gcm_noise(dimlevs) ! perturbations to add to temperatures

! local variables:
      real old_ps_noise_dev ! to store value from previous calls
      data old_ps_noise_dev /-77./ ! dummy initial value
      save old_ps_noise_dev 

      real ps_noise_level ! standard deviation of (relative) pert. in pressure
      parameter (ps_noise_level=0.01) !  e.g. 0.02=2%
      
      real T_noise_level ! standard deviation of pert in temperature (K)
      parameter (T_noise_level=3) ! e.g. 5K
      
      real T_noise_mid ! altitude (m) at which temp pert. will be half of max
      parameter (T_noise_mid=6000)
      
      real T_noise_delta ! range (m) over which noise drops from max to zero
      parameter (T_noise_delta=4000)

      integer lay
      real coeff ! altitude-dependent coefficient for temperature pert.
      
      if (ps_noise_dev.ne.old_ps_noise_dev) then ! compute perturbations
      
        ! 1. surface pressure perturbation
        ps_noise=ps*ps_noise_dev*ps_noise_level
!        write(*,*) 'ps_noise_dev=',ps_noise_dev,
!     &             ' temp_gcm_noise_dev=',temp_gcm_noise_dev
!        write(*,*) 'ps=',ps,
!     &             ' ps_noise=',ps_noise
        
        ! 2. atmospheric temperature perturbations
        do lay=1,dimlevs
          coeff=0.5*(1.-tanh(6.*(sheight(lay)-T_noise_mid)/T_noise_delta))
          temp_gcm_noise(lay)=T_noise_level*coeff*temp_gcm_noise_dev
!          write(*,*) 'l=',lay,'sheight(l)=',sheight(lay),
!     &                 'temp_gcm_noise(l)=',temp_gcm_noise(lay)
        enddo
        
        ! reset old_ps_moise_dev
        old_ps_noise_dev=ps_noise_dev
      endif ! of if (ps_noise_dev.ne.old_ps_noise_dev)
      
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine colint(aps,bps,oroheight,ps_gcm,ps_hr,R_gcm,temp_gcm,col_gcm,col_hr)
!
!     Computes number of mol. between levels for hi and GCM resolution
!     Used for correction of column in hires. 
!

      use MCD_var, only : dimlevs, a0, g0


      implicit none
      
!     inputs
      real,intent(in) :: aps(dimlevs)      ! hybrid coordinate 
      real,intent(in) :: bps(dimlevs)      ! hybrid coordinate      
      real,intent(in) :: oroheight         ! height of surface above reference areoid (m)
      real,intent(in) :: ps_gcm            ! surface pressure (Pa)
      real,intent(in) :: ps_hr             ! surface pressure (Pa)
      real,intent(in) :: R_gcm(dimlevs)    ! R at GCM levels
      real,intent(in) :: temp_gcm(dimlevs) ! temperature at GCM levels

!     outputs
      real,intent(out) :: col_gcm(dimlevs) ! number of mol. between levels !! actual dimension used is: dimlevs-1 !!
      real,intent(out) :: col_hr(dimlevs)  ! number of mol. between levels !! actual dimension used is: dimlevs-1 !!      

!     local variables
      integer       l
!     Gravity on mean areoid
!     The areoid is defined as a surface of constant gravitational plus
!     rotational potential. The inertial rotation rate of Mars is assumed
!     to be 0.70882187E-4 rad/s. This potential is the mean value at the
!     equator at a radius of 3396.000 km, namely 12652804.7 m^2/s^2,
!     calculated from Goddard Mars Gravity Model mgm1025
!     [LEMOINEETAL2001] evaluated to degree and order 50.
      real          g

      real          Tmean            ! "mean" temperature of a layer
      real          Rogct
      real          sig_gcm(dimlevs) ! sigma levels
      real          sig_hr(dimlevs)  ! sigma levels
      real          x(dimlevs)       ! the stub for compatibility
      real          h_low,h_hi       ! height above surface     

      ! GCM sigma levels
      do l=1,dimlevs
        sig_gcm(l)=aps(l)/ps_gcm+bps(l)
      enddo
      ! high res sigma levels
      call build_sigma_hr(sig_gcm,ps_gcm,ps_hr,sig_hr,x)
!      
!     Calculate altitude above the surface of each model layer: h(l)
!     integrate hydrostatic equation
!
      g     = g0*(a0/(a0+oroheight))**2
      Rogct = R_gcm(1)/g
      h_low =-Rogct*temp_gcm(1)*log(sig_gcm(1))
      h_hi  =-Rogct*temp_gcm(1)*log(sig_hr(1))

      do l=2, dimlevs
       if (temp_gcm(l).ne.temp_gcm(l-1)) then
        Tmean = real((dble(temp_gcm(l)-temp_gcm(l-1))) /dlog(dble(temp_gcm(l))/dble(temp_gcm(l-1))))
       else
        Tmean = temp_gcm(l)
       end if
       ! For GCM 
       g = g0*(a0/(a0+oroheight+h_low))**2
       Rogct = R_gcm(l)/g
       h_low = h_low - Rogct*Tmean*log(sig_gcm(l)/sig_gcm(l-1))
       col_gcm(l-1)=-Rogct/1.380648e-23*(sig_gcm(l)-sig_gcm(l-1))*ps_gcm
       ! For hires
       g = g0*(a0/(a0+oroheight+h_hi))**2
       Rogct = R_gcm(l)/g
       h_hi = h_hi - Rogct*Tmean*log(sig_hr(l)/sig_hr(l-1))
       col_hr(l-1) =-Rogct/1.380648e-23*(sig_hr(l)-sig_hr(l-1))*ps_hr
      end do

      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine colcor(a,lon,lat,utime,name,ier,itimint,wl,wh,col_gcm,col_hr)
!
!     Calculate the ratio of column in hi res to column in GCM res. 
!     Used for correction of the column in hires.
!

      use MCD_var, only : dimlevs


      implicit none

!     inputs
      real,            intent(in)  ::  lon              ! east longitude of point
      real,            intent(in)  ::  lat              ! latitude of point
      real,            intent(in)  ::  utime            ! Universal time (0. to 24. hrs)=local time at lon=0
      character(len=*),intent(in)  ::  name             ! Name of variable
      integer,         intent(in)  ::  itimint          ! seasonal interpolation flag (1==yes,0==no)
      real,            intent(in)  ::  wl,wh            ! weights for seasonal interpolation      
      real,            intent(in)  ::  col_gcm(dimlevs) ! Number of mols between GCM levels
      real,            intent(in)  ::  col_hr(dimlevs)  ! Number of mol between hr leves 

!     outputs
      real,            intent(out) ::  a                ! col_hr/col_gcm
      integer,         intent(out) ::  ier              ! error flag (0=OK, not 0 =NOK)

!     local variables
      integer       l
      real          x_gcm,x_hr,vmr,cor
      real          vmr_gcm(dimlevs)      
           
      call profi(vmr_gcm,lon,lat,utime,name,ier,itimint,wl,wh,0,0,0)
      
      x_gcm = 0.0
      x_hr  = 0.0
      do l=2,dimlevs
       vmr = 0.5*(vmr_gcm(l-1)+vmr_gcm(l))
       x_gcm = x_gcm + col_gcm(l-1)*vmr
       x_hr  = x_hr  + col_hr( l-1)*vmr
      enddo
      a = x_hr/x_gcm 
          
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine profi(a,lon,lat,utime,name,ier,itimint,wl,wh,flag_ini,ib,ie)

!     Retrieve a vertical profile of 3-d variable=name at east longitude=lon,
!     latitude=lat and universal time=utime.
!     horizontal bilinear interpolation is used for all variables exept
!     density, for which the horizontal interpolation is bilinear
!     interpolation of log(rho)
!     Note: see routine loadvar_mcd.F about the way data arrays are organized.
! IMPORTRANT: order of variables here must match order in "loadvar_mcd"
!
! flag_ini = 0 : NO initialization, use previously computed values (if possible)
! flag_ini = 1 : DO initialization for ALL variables and exit
! flag_ini > 1 : DO initialization for particular variable and extract the profile
! 
! The profile is extracted for indexes from ib to ie.
! If ib=0 and ie=0 the complete profile is extracted (from 1 to dimlevs)
! For any other ie,ib the profile is extracted for 1<=index_begin<=dimlevs, 1<=index_end<=dimlevs.
! If ib>ie then error.
! If lon=var_lon AND lat=var_lon AND utime=var_tuime AND  var_ib<=ib AND ie<=var_ie  the stored profile is taken.
!

      use MCD_var, only : nbsd3d, nbvar3d, varname3d, var_3d, var_3d2, varrms3d, vararms3d, &
                          varrms3d2, vararms3d2, dimlevs, out, output_messages


      implicit none

!     inputs
      real,            intent(in)  :: lon        ! east longitude of point
      real,            intent(in)  :: lat        ! latitude of point
      real,            intent(in)  :: utime      ! Universal time (0. to 24. hrs)=local time at lon=0
      character(len=*),intent(in)  :: name       ! Name of variable
      integer,         intent(in)  :: itimint    ! seasonal interpolation flag (1==yes,0==no)
      real,            intent(in)  :: wl,wh      ! weights for seasonal interpolation  
      integer,         intent(in)  :: ib,ie      ! begin end indexes
      integer,         intent(in)  :: flag_ini   ! flag of initialization (in the case of new season or scenario)
                                                 ! 0= no initialization; 
                                                 ! 1= do initialization and exit; 
                                                 ! 1> do initialization and profile
!     outputs
      integer,         intent(out) :: ier        ! error flag (0=OK, 1=Not OK)
      real,            intent(out) :: a(dimlevs) ! Interpolated profile 

!     local variables
      integer  i,j,l    ! for loops
!      integer  k,sd,rms,arms ! flags/index of variable
      integer  itime(2) ! nearest MCD time indexes (1-12)
      integer  iut      ! temporary variable to store itime()
      integer  dlon(4)  ! longitude indexes of nearby MCD grid points
      integer  dlat(4)  ! latitude indexes of nearby MCD grid points
      integer  idlon ! to store dlon(i) outside i loop to save time (?)
      integer  idlat ! to store dlat(i) outside i loop to save time (?)
      real     t,u ! weights for horizontal (bilinear) interpolation
      real     w ! weight for time-of-day interpolation
      real     y(2,dimlevs,4) ! low/hi, MCD profiles at nearby grid points
      real     x(2,dimlevs,2) ! low/hi, horizontally interpolated y() at times itime()
      real     b(2,dimlevs)
      
      integer  ivar,it,k,var_type
      integer  indxb,indxe ! begin, end index for the profile extraction
      integer,parameter :: nvar = nbvar3d+nbsd3d+(nbsd3d+1)
! var_a() is a profile at var_lon(),var_lat(), var_utime() for ivar
      real, save :: var_lon(nvar)      
      real, save :: var_lat(nvar)
      real, save :: var_utime(nvar)
      real, save :: var_a(nvar,dimlevs)
      real, save :: var_wl(nvar)
      
      integer, save :: var_ib(nvar)
      integer, save :: var_ie(nvar)    
      
      character*12 rmsname(nbsd3d)    /'rmstemp', 'rmsu', 'rmsv','rmsrho', 'rmsw'/
      character*12 armsname(nbsd3d+1) /'armstemp','armsu','armsv','armsrho','armsw','armspressure'/

      ier=0    ! initialize error flag to 0 (== OK)
!
! flag_ini=1 
! Initialization for ALL variables (e.g. in case of a new season or scenario)
! by some dummy "unrealistic" values
! 

      if(flag_ini.eq.1) then
       do ivar=1,nvar
        var_lon(ivar)   = 1000.0
        var_lat(ivar)   = 1000.0
        var_utime(ivar) = 1000.0
        var_ib(ivar)    =-1
        var_ie(ivar)    =-1
        var_wl(ivar)    =-1
       enddo
       return 
      endif

! associate variable with name
! var_type: 0=sd; 1=rms; 2=arms
! k       : index in the array
! ivar    : index of the profile 
!
      do var_type=0,2
       if(var_type.eq.0) then
        do k=1,nbvar3d
         if(varname3d(k).eq.name) then          
          ivar = k
          goto 1111
         endif 
        enddo
       elseif(var_type.eq.1) then
        do k=1,nbsd3d
         if(rmsname(k).eq.name) then          
          ivar = nbvar3d+k
          goto 1111
         endif   
        enddo
       elseif(var_type.eq.2) then
        do k=1,(nbsd3d+1)
         if(armsname(k).eq.name) then          
          ivar = nbvar3d+nbsd3d+k
          goto 1111
         endif   
        enddo   
       endif    
      enddo




!     CASE of an unexpected name
      if(output_messages) then
       write(out,*) 'problem using subroutine profi : the name ',trim(name)
       write(out,*) 'is not recognized'
      endif
      ier=1
      stop
      
1111  continue

!
! flag_ini>1
! Initialization for a particular variable and proceed (i.e. as in "old" version) 
!
      if(flag_ini.gt.1) then
       var_lon(ivar)   = 1000.0
       var_lat(ivar)   = 1000.0
       var_utime(ivar) = 1000.0
       var_ib(ivar)    =-1
       var_ie(ivar)    =-1
       var_wl(ivar)    =-1       
      endif
!
! if ib=0 and ie=0 extract full profile: from 1 to dimlevs
! else for any ie,ib: 1<=lb<=dimlevs, 1<=le<=dimlevs 
! if lb>le: error
!      
      if(ib.eq.0.and.ie.eq.0) then
       indxb = 1
       indxe = dimlevs
      else
       indxb = ib
       indxe = ie
       ! check beginning and ending index coherence
       if(indxb.lt.1.or.indxe.gt.dimlevs.or.indxb.gt.indxe) then
        if (output_messages) then
         write(out,*) 'profi() : problem with indexes ibegin=',indxb,' iend=',indxe
        endif
        ier=1
        stop
       endif ! indxb>indxe 
      endif ! else if ib=0 and ie=0    
!          
!
!
      if(wl.eq.var_wl(ivar)) then
       if(utime.eq.var_utime(ivar)) then
        if(lon.eq.var_lon(ivar)) then
         if(lat.eq.var_lat(ivar)) then
          if(indxb.ge.var_ib(ivar).and.indxe.le.var_ie(ivar)) then   
           do l=indxb,indxe
            a(l) = var_a(ivar,l)          
           enddo
           return
          endif
         endif    
        endif    
       endif
      endif   


     
!     Retrieving variable for  "lower" season
!     ------------------------------------------------
!     find the 4 neighbouring MCD grid points
      call grid4(lon,lat,dlon,dlat,t,u)
!     find nearest 2 timestep :
      call mcd_time(utime,itime,w) 
!
! it=1 Retrieving variable for "lower season"
! it=2 Retrieving variable for "higher" season (if seasonal interpolation)
! 
      do it=1,2
!     --------------------------------------
!     For seasonal interpolation
!     loop on the 2 nearest timestep :
      do j = 1 , 2
         iut = itime(j) ! MCD time
!        get 4 profiles at those points
!    MEAN variables
       if (var_type.eq.0) then
            do i=1,4
              idlon=dlon(i)
              idlat=dlat(i)
               do l=indxb,indxe
                 if(it.eq.1) then  
                  y(it,l,i)=var_3d(idlon,idlat,l,iut,k)
                 else
                  y(it,l,i)=var_3d2(idlon,idlat,l,iut,k)   
                 endif    
               enddo
            enddo
       endif!sd=0
!    RMS variables
       if (var_type.eq.1) then
           do i=1,4
             idlon=dlon(i)
             idlat=dlat(i)
              do l=indxb,indxe
               if(it.eq.1) then   
                y(it,l,i)=varrms3d(idlon,idlat,l,k)
               else
                y(it,l,i)=varrms3d2(idlon,idlat,l,k)   
               endif    
              enddo
           enddo
       endif
!    ARMS variables
       if (var_type.eq.2) then
           do i=1,4
             idlon=dlon(i)
             idlat=dlat(i)
              do l=indxb,indxe
               if(it.eq.1) then   
                y(it,l,i)=vararms3d(idlon,idlat,l,k)
               else
                y(it,l,i)=vararms3d2(idlon,idlat,l,k)   
               endif    
              enddo
           enddo
       endif

       if ((name.eq.'rho').or.(name.eq.'tsdrho').or.(name.eq.'rmsrho').or.(name.eq.'armsrho').or.(name.eq.'armspressure')) then
!    bilinear interpolation of log(rho)
         do l=indxb,indxe
          x(it,l,j)=(1.-t)*(1.-u)*log(y(it,l,1))+t*(1.-u)*log(y(it,l,2))+t*u*log(y(it,l,3))+(1.-t)*u*log(y(it,l,4))
          x(it,l,j)=exp(x(it,l,j))
         enddo
       else
!    bilinear interpolation
         do l=indxb,indxe
           x(it,l,j)=(1.-t)*(1.-u)*y(it,l,1)+t*(1.-u)*y(it,l,2)+t*u*y(it,l,3)+(1.-t)*u*y(it,l,4)
         enddo
       endif
      enddo! loop on 2 nearest MCD timestep

!    linear interpolation in (hour-of-day) time :
      do l=indxb,indxe
        b(it,l) = w*x(it,l,1) + (1-w)*x(it,l,2)
!      if(k.eq.4) write(out,*)'l,t ',l,a(l)
      enddo

      if(itimint.lt.1) exit ! if NO seasonal interpolation
      
      enddo ! it
!      
!     Season interpolation between the two seasons
!     --------------------------------------------
      if(itimint.lt.1) then      
       do l=indxb,indxe
        a(l) = b(1,l)
       enddo 
      else
       do l=indxb,indxe 
        a(l) = (wl)*b(1,l) + (wh)*b(2,l) 
       enddo
      endif     
!
! store the profile (from indxb to indxe)
!
      do l=indxb,indxe
       var_a(ivar,l) = a(l)   
      enddo    
      var_lat(ivar)   = lat
      var_lon(ivar)   = lon
      var_utime(ivar) = utime
      var_ib(ivar)    = indxb
      var_ie(ivar)    = indxe
      var_wl(ivar)    = wl

      end
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine read_dust_scenario(dust,slon,slat,zday,dset,tauref,ier)
      
      
      use netcdf
      
      use MCD_var, only : out, output_messages
    
!      Reading of the dust scenario file
      implicit none


      real,          intent(in)  :: slon,slat ! longitude and latitude where interpolate
      integer,       intent(in)  :: dust      ! dust scenario
      real,          intent(in)  :: zday      ! date in martian days
      character*(*), intent(in)  :: dset      ! Dataset

 
      real,          intent(out) :: tauref   ! Daily mean visible dust opacity at 610 Pa
      integer,       intent(out) :: ier      ! Error code

!     Local variables

      integer, save :: dustprec = 0
      real :: realday
      integer nid,nvarid,ierr
      integer ltloop,lsloop,iloop,jloop,varloop,ig
      real, dimension(2) :: taubuf
      real tau1(4),tau
      real alt(4)
      integer latp(4),lonp(4)
      integer yinf,ysup,xinf,xsup,tinf,tsup
      real latinf,latsup,loninf,lonsup
      real latintmp,lonintmp
      real colat,dlat,dlon,colattmp
      logical, save :: firstcall=.true.
      logical :: timeflag
      real,save :: radeg,pi
      integer :: timedim,londim,latdim
      real, dimension(:), allocatable, save :: lat,lon,time
      real, dimension(:,:,:), allocatable, save :: tautes
      integer, save :: timelen,lonlen,latlen
      character(len=33),save :: filename

      realday=mod(zday,669.)
      
!    Check inputs : 
     
         
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          Loading data if dust has changed since last call           c
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


!    Test if  we have changed the dust scenario since last call of call_mcd

      if (dust.ne.dustprec) then
      
      dustprec = dust
      
      if(allocated(tautes)) deallocate(tautes)	
      if(allocated(lon)) deallocate(lon)
      if(allocated(lat)) deallocate(lat)
      if(allocated(time)) deallocate(time)
      
!      if allocated deallocate(lat,lon,time,tautes)
      
       pi=acos(-1.)
       radeg=180/pi
   
!    assimilated dust file: 
!    dust=1,2,3 means read dust_clim.nc file
!    dust=7 means read dust_warm.nc file
!    dust=8 means read dust_cold.nc file
!    dust=24 means read dust_MY24.nc file
!    dust=25 means read dust_MY25.nc file
!    dust=26 means read dust_MY26.nc file etc...

   
      if (dust.eq.1 .or. dust.eq.2 .or. dust.eq.3) then
          filename="dust_clim.nc"
      else if (dust.eq.7) then
          filename="dust_warm.nc"
      else if (dust.eq.8) then
          filename="dust_cold.nc"    
      elseif(dust.ge.24) then
        write(filename, fmt ='(a,i2.2,a)') "dust_MY", dust,".nc"
      endif         

!     Opening dust_scenario 

      if(output_messages) then 
        write(out,*) 'Opening ', trim(dset)//'dust_high_resol/'//trim(filename)
      endif
        
      ierr=nf90_open(trim(dset)//'dust_high_resol/'//trim(filename),nf90_nowrite,nid)
     
      if (ierr.ne.nf90_noerr) then
       ier = 15   
       if(output_messages) then
         write(out,*) "Error in read_dust_scenario : cannot open file ",trim(dset)//'dust_high_resol/'//trim(filename)
       endif
       return
      endif
      
      
!     Load time dimension 
 
      ierr=nf90_inq_dimid(nid,"Time",timedim)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
         write(out,*)"Error: read_dust_scenario <time> not found"
       endif
       return
      endif
  
      ierr=nf90_inquire_dimension(nid,timedim,len=timelen)
      
!     Load latitude dimension
      
      ierr=nf90_inq_dimid(nid,"latitude",latdim)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*)"Error: read_dust_scenario <latitude> not found"
       endif
       return
      endif
      
      ierr=nf90_inquire_dimension(nid,latdim,len=latlen)
      
!     Load longitude dimension
      
      ierr=nf90_inq_dimid(nid,"longitude",londim)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
           write(out,*)"Error: read_dust_scenario <longitude> not found"
       endif
       return 
      endif
       
      ierr=nf90_inquire_dimension(nid,londim,len=lonlen)


      allocate(tautes(lonlen,latlen,timelen))
      allocate(lat(latlen), lon(lonlen), time(timelen))
      
!     Load IR absorption opacity opacity 
   
      ierr=nf90_inq_varid(nid,"cdod",nvarid)
      ierr=nf90_get_var(nid,nvarid,tautes)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_dust_scenario <cdod> not found"
        write(out,*) trim(nf90_strerror(ierr))        
       endif
       return
      endif
      
      
!     multiply by 2*1.3=2.6 to convert from IR (9.3 microms) absorption
!     to visible extinction opacity
      
      tautes(:,:,:)=2.6*tautes(:,:,:)
      

!     Get values of time  

      ierr=nf90_inq_varid(nid,"Time",nvarid)
      ierr=nf90_get_var(nid,nvarid,time)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_dust_scenario <Time> not found"
        write(out,*) trim(nf90_strerror(ierr))
       endif
       return
      endif
      
!     Get values of latitude   

      ierr=nf90_inq_varid(nid,"latitude",nvarid)
      ierr=nf90_get_var(nid,nvarid,lat)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_dust_scenario <latitude> not found"
        write(out,*) trim(nf90_strerror(ierr))
       endif
       return
      endif
      
!     Get values of longitude   

      ierr=nf90_inq_varid(nid,"longitude",nvarid)
      ierr=nf90_get_var(nid,nvarid,lon)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_dust_scenario <longitude> not found"
        write(out,*) trim(nf90_strerror(ierr))
       endif
       return
      endif
      
      ierr=nf90_close(nid)   

      endif ! of if (dust.ne.dustprec)
      

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          Bilinear interpolation at desired point and time           c
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


!     Find the four nearest points, arranged as follows:
!                               1 2
!                               3 4

      colat=90-slat   ! colatitude, in degrees

!     Find encompassing latitudes
      
      if (colat<(90-lat(1))) then ! between north pole and lat(1)
       ysup=1
       yinf=1
      else if (colat>=90-(lat(latlen))) then ! between south pole and lat(laten)
       ysup=latlen
       yinf=latlen
      else ! general case
      do iloop=2,latlen
         if(colat<(90-lat(iloop))) then
           ysup=iloop-1
           yinf=iloop
           exit
         endif
      enddo
      endif
      
      latinf=lat(yinf)
      latsup=lat(ysup)

!     Find encompassing longitudes
!     Note: in input file, lon(1)=-180.
      if (slon>lon(lonlen)) then
       xsup=1
       xinf=lonlen
       loninf=lon(xsup)
       lonsup=180.0 ! since lon(1)=-180.0
      else
      do iloop=2,lonlen         
         if(slon<=lon(iloop)) then
              xsup=iloop
              xinf=iloop-1
              exit
         endif
      enddo
      loninf=lon(xinf)
      lonsup=lon(xsup)
      endif

      if ((xsup.gt.lonlen).or.(yinf.gt.latlen).or.(xinf.lt.1).or.(ysup.lt.1)) then
       ier = 16
       if(output_messages) then
        write (out,*) "read_dust_scenario: SYSTEM ERROR on x or y"
        write (out,*) "xinf: ",xinf
        write (out,*) "xsup: ",xsup
        write (out,*) "yinf: ",yinf
        write (out,*) "ysup: ",ysup
       endif
       return
      endif



!     The four neighbouring points are arranged as follows:
!                               1 2
!                               3 4

      latp(1)=ysup
      latp(2)=ysup
      latp(3)=yinf
      latp(4)=yinf

      lonp(1)=xinf
      lonp(2)=xsup
      lonp(3)=xinf
      lonp(4)=xsup

!     Linear interpolation on time, for all four neighbouring points

      if ((realday<time(1)).or.(realday>time(timelen))) then
       tinf=timelen
       tsup=1
       timeflag=.true.
      else 
       timeflag=.false.
       do iloop=2,timelen
         if (realday<=time(iloop)) then
            tinf=iloop-1
            tsup=iloop
            exit
         endif
       enddo
      endif
      

!     Bilinear interpolation on the four nearest points

      if ((colat<(90-lat(1))).OR.(colat>(90-lat(latlen))).OR.(latsup==latinf)) then
       dlat=0
      else
      dlat=((90-latinf)-colat)/((90-latinf)-(90-latsup))
      endif

      if (lonsup==loninf) then
       dlon=0
      else
       dlon=(slon-loninf)/(lonsup-loninf)
      endif

!     Temporal Interpolation

      do iloop=1,4
       taubuf(1)=tautes(lonp(iloop),latp(iloop),tinf)
       taubuf(2)=tautes(lonp(iloop),latp(iloop),tsup)
      if (timeflag) then
         if (realday>time(timelen)) then
            tau1(iloop)=taubuf(1)+(taubuf(2)-taubuf(1))*(realday-time(tinf))/(time(tsup)+(669-time(tinf))) 
         else
            tau1(iloop)=taubuf(1)+(taubuf(2)-taubuf(1))*realday/(time(tsup)+(669-time(tinf)))
         endif
      else
         tau1(iloop)=taubuf(1)+(taubuf(2)-taubuf(1))*(realday-time(tinf))/(time(tsup)-time(tinf))
      endif
      if (tau1(iloop)<0) then
       ier = 16
       if(output_messages) then
          write (out,*) "read_dust_scenario: SYSTEM ERROR on tau"
          write (out,*) "utime ",realday
          write (out,*) "time(tinf) ",time(tinf)
          write (out,*) "time(tsup) ",time(tsup)
          write (out,*) "tau1 ",taubuf(1)
          write (out,*) "tau2 ",taubuf(2)
          write (out,*) "tau ",tau1(iloop)
        endif
        return
      endif
      enddo

!     Spatial Interpolation

      if ((dlat>1).OR.(dlon>1) .OR. (dlat<0) .OR. (dlon<0)) then
       ier = 16
       if(output_messages) then
        write (out,*) "read_dust_scenario: SYSTEM ERROR on dlat or dlon"
        write (out,*) "dlat: ",dlat
        write (out,*) "lat: ",slat
        write (out,*) "dlon: ",dlon
        write (out,*) "lon: ",slon
       endif
       return
      endif
      

      tauref= dlat*(dlon*(tau1(2)+tau1(3)-tau1(1)-tau1(4))+tau1(1)-tau1(3)) +dlon*(tau1(4)-tau1(3))+tau1(3)
     
      end
      
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine get_slopes(dset,longitude,latitude,s_scale,oro_radius,theta_s,psi_s,ier)

      implicit none

    
! Arguments

! Inputs

      character*(*), intent(in)  :: dset        ! Path to MCD datafiles 
      real,          intent(in)  :: latitude    ! north latitude (degrees)
      real,          intent(in)  :: longitude   ! east longitude (degrees)
      real,          intent(in)  :: s_scale     ! Distance from central point (m)
      real,          intent(in)  :: oro_radius  ! Distance from the center of the planet to orography (m)

! Outputs

      real,          intent(out) :: theta_s     ! Slope inclination (deg) (horizontal = 0, vetical = 90)  
      real,          intent(out) :: psi_s       ! Slope orientation (deg) (Northward = 0 , eastward = 90)      
      integer,       intent(out) :: ier         ! error integer, if 0 ok 

! Local variables
      
      real distance   		! s_scale in m
      
      real lonA, lonB, lonC     ! longitude of ABC points
      real latA, latBC          ! latitude of ABC points, B and C have the same
      real hA, hB, hC

      double precision pi,degtorad  ! Constants
      parameter (pi=3.14159265358979d0)
      parameter (degtorad=pi/180.0d0)





! 1. Computation of the coordinates of A, B and C
      distance = s_scale*1000.
      
      latA = latitude + distance/(oro_radius*degtorad)

      latBC = latitude - distance/(2.*oro_radius*degtorad)
      
      if(latA.le.-90.) latA=-latA-180.   
      if(latBC.le.-90.) latBC=-latBC-180.
                
      if(latA.ge.90.) latA=180.-latA   
      if(latBC.ge.90.) latBC=180.-latBC   
      
      lonA = longitude
      lonB = longitude+distance*sqrt(3.)/(2*oro_radius*cos(latBC*degtorad)*degtorad)
      lonC = longitude-distance*sqrt(3.)/(2*oro_radius*cos(latBC*degtorad)*degtorad)
     
      if(lonA.le.-180.) lonA=lonA+360.   
      if(lonB.le.-180.) lonB=lonB+360.   
      if(lonC.le.-180.) lonC=lonC+360.   
            
      if(lonA.ge.180.) lonA= lonA-360. 
      if(lonB.ge.180.) lonB= lonB-360. 
      if(lonC.ge.180.) lonC= lonC-360. 
          

! 2. Call mola to get hA, hB and hC
      call mola(dset,latA,lonA,hA,ier)
      call mola(dset,latBC,lonB,hB,ier)
      call mola(dset,latBC,lonC,hC,ier)


! 3 comptuation of costheta and psi_s

      if ((hA**2+ hB**2+ hC**2 - (hA*hB+hC*hA+hB*hC)).le.0) then
         theta_s=0
      else

         theta_s=atan2(2*sqrt(hA**2+hB**2+hC**2-(hA*hB+hC*hA+hB*hC)),3*distance)
      endif

      theta_s = theta_s/degtorad
      
      psi_s = atan2(sqrt(3.)*(hC-hB),hB + hC - 2*hA)
      
      psi_s = psi_s/degtorad
      
      end 


!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine get_irradiance(longitude,latitude,loct,ls,Ftot_0,Fdir_0,solzenang,taudust,col_h2oice,theta_s,psi_s,F,ier)


      implicit none 


! Arguments
! inputs

      real,   intent(in)  :: latitude   ! north latitude (degrees)
      real,   intent(in)  :: longitude  ! east longitude (degrees)
      real,   intent(in)  :: loct       ! local time (hour)
      real,   intent(in)  :: ls         ! solar longitude (degrees) 
      real,   intent(in)  :: Ftot_0     ! Incident solar flux on horizontal surface (W/m2)
      real,   intent(in)  :: Fdir_0     ! Incident direct incoming solar flux on horizontal surface (W/m2)      
      real,   intent(in)  :: solzenang  ! solar zenith angle (deg)
      real,   intent(in)  :: taudust    ! dust optical depth
      real,   intent(in)  :: theta_s    ! slope inclination (deg) (horizontal = 0, vetical = 90)
      real,   intent(in)  :: psi_s      ! slope orientation (deg) (Northward = 0 , eastward = 90)
      real,   intent(in)  :: col_h2oice ! water ice column (kg/m2)

! outputs
      real,   intent(out) :: F          ! Incident solar flux on local slope (W/m2)
      integer,intent(out) :: ier        ! returned status code (==0 if OK)

! Local variables
      real :: declin                ! sun declination (deg to rad) 
      real :: rho                   ! sun right ascension (rad)
      real :: csza                  ! cosine solar zenith angle

      real :: Fscat_0               ! reference scattered flux
      real :: albedo                ! albedo value
   
      real :: costheta_s, sintheta_s, sigma_s ! slopes values, from get_slopes
      real :: mu_s                  ! cos of solar zenith angle on slope

      real :: a                     ! to compute mu_s
      real :: tauice                ! Ice clouds opacity

      real :: M_mat(4,2), N_mat(4,2), T_mat(4,2) ! coupling matrix
      real :: g_vect(2), s_vect(4)  ! vectors fo scattered flux
      real :: ratio                 ! Between scattered flux on horizontal and on slope      

      real :: Fdir, Fscat, Fref     ! Direct, scattered and reflected flux
 
      real    pi,degtorad           ! Constants
      
   
      parameter (pi=3.14159265358979d0)
      parameter (degtorad=pi/180.0d0)
      
      real, parameter :: Qext = 2          ! single scattering extinction coefficient
      real, parameter :: rho_ice = 920     ! ice density kg.m-3
      real, parameter :: reff_ice = 5.e-6  ! ice radius m
      
      double precision,parameter :: obliquity=25.1919d0
      
      

      csza = cos(degtorad*solzenang)
!     
      if (csza .lt. 0.01) then
         fdir=0.
         fscat_0=0.
         fscat=0.   
         fref=0.
         mu_s=0.5
      else

! slopes values

         costheta_s = cos(degtorad*theta_s)
         sintheta_s = sin(degtorad*theta_s)
         sigma_s = (1.+costheta_s)/2.


! 
         albedo = 0.2

      ! sun values
      ! Compute Sun's declination
         declin=asin(sin(ls*degtorad)*sin(obliquity*degtorad))
         rho = pi * (1. -  loct/12.)

! 'Slope vs Sun' azimuth (radian)
         if ( ( (cos(declin)*sin(rho)) .eq. 0.0 ).and.(( sin(degtorad*latitude)*cos(declin)*cos(rho)- &
                 cos(degtorad*latitude)*sin(declin) ) .eq. 0.0 )) then
            a = degtorad*psi_s  ! some compilator need specfying value for atan2(0,0)  
         else
            a = degtorad*psi_s + atan2( cos(declin)*sin(rho), sin(degtorad*latitude) & 
                *cos(declin)*cos(rho)-cos(degtorad*latitude)*sin(declin))
         end if
         

! Cosine of slope-sun phase angle 
         mu_s = csza*costheta_s - cos(a)*sintheta_s*sqrt(1.-csza**2)

         if (mu_s .le. 0.) mu_s=0.

! direct and reflected flux

         !Fdir_0 =  (solar_const/(marsau**2)) * csza * exp(- (taudust + 326. * col_h2oice)/csza)
         ! This field is now read in the data files from GCM simulation
        
         Fdir = Fdir_0 * mu_s/csza
         Fref = albedo * (1-sigma_s) * Ftot_0
         
! scattering flux
         Fscat_0 = Ftot_0 - Fdir_0
         Fscat_0 = max(Fscat_0,Ftot_0/100.)  ! to avoid F_scat <0 due to averaging of Ftot_0 over several months

         tauice = (3*col_h2oice*Qext)/(4*rho_ice*reff_ice)
         g_vect = (/ mu_s/csza, 1. /)        
         s_vect = (/ 1. , exp(-(taudust+tauice)) , sintheta_s , exp(-(taudust+tauice))*sintheta_s /)

         if (csza.ge.0.5) then
            M_mat(:,1)=(/ -0.264,  1.309,  0.208, -0.828 /)
            M_mat(:,2)=(/ 1.291*sigma_s, -1.371*sigma_s, -0.581,1.641/)
            N_mat(:,1)=(/ 0.911, -0.777, -0.223,  0.623 /)
            N_mat(:,2)=(/ -0.933*sigma_s, 0.822*sigma_s, 0.514,-1.195/)

         else
            M_mat(:,1)=(/ -0.373,  0.792, -0.095,  0.398 /)
            M_mat(:,2)=(/ 1.389*sigma_s, -0.794*sigma_s, -0.325,0.183/)
            N_mat(:,1)=(/  1.079,  0.275,  0.419, -1.855 /)
            N_mat(:,2)=(/ -1.076*sigma_s, -0.357*sigma_s, -0.075,1.844/)
         endif

         T_mat = M_mat + csza*N_mat


         if (degtorad*theta_s <= 0.0872664626) then
          !
          ! low angles
          !
            s_vect = (/ 1., exp(-taudust) , sin(0.0872664626), sin(0.0872664626)*exp(-taudust) /)
            ratio = DOT_PRODUCT ( MATMUL( s_vect, T_mat), g_vect )
            ratio = 1. + (ratio - 1.)*degtorad*theta_s/0.0872664626
         else
          !
          ! general case
          !
            ratio= DOT_PRODUCT ( MATMUL( s_vect, T_mat), g_vect )
                  !
                  ! NB: ratio= DOT_PRODUCT ( s_vect, MATMUL( mat_T, g_vect ) ) is equivalent
         endif
         
         Fscat = ratio * Fscat_0
         
      endif

      F = fdir + fref + fscat

      end 


!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
     
      subroutine slope_winds(lati,theta_s,psi_s,zsurface,rgas,cp,temp_gcm,ps_hr,sigma,sheight_0,    &   
                             upslope_wind,crossslope_wind,zonal_slope_wind, merid_slope_wind,temp)     
     
           
      use MCD_var, only : dimlevs

      implicit none
      
      
      ! Inputs
      
      real, intent(in)  :: zsurface                  ! Height above surface  (m)
      real, intent(in)  :: temp_gcm(dimlevs)         ! temperatire at GCM levels (K)
      real, intent(in)  :: sheight_0(dimlevs)        ! altitude above surface of GCM sigma levels (m)
      real, intent(in)  :: sigma(dimlevs),ps_hr      ! ration pres/pres_surface, high resolution surface pressure (Pa)
 
      real, intent(in)  :: lati                      ! Latitude (deg) 
      real, intent(in)  :: theta_s                   ! slope inclination (deg) (horizontal = 0, vetical = 90)
      real, intent(in)  :: psi_s                     ! slope orientation (deg) (Northward = 0 , eastward = 90)
      
      real, intent(in)  :: rgas                      ! R_gaz/mean molar mass (J/kg/mol)
      real, intent(in)  :: cp                        ! heat capacity (J/kg/K)
      
      

      ! Outputs
      
      real, intent(out) :: upslope_wind              ! slope wind component along slope (m/s)
      real, intent(out) :: crossslope_wind           ! slope wind component crossing slope (m/s)
      
      real, intent(out) :: zonal_slope_wind          ! slope wind component along west-east direction (m/s)
      real, intent(out) :: merid_slope_wind          ! slope wind component along south-north direction (m/s)
     
      real, intent(out) :: temp                      ! temperature perturbation, source of slope winds (K)

      
      ! Varibles for reference
     
      real    zfree                                 ! Altitude at which temperature is not influenced by slope (m)
      real    zfree_0                               ! Altitude at which temperature is not influenced by slope (m) (for z=0)
      real    zlim                                  ! Altitude at which buoyancy force is null (m)  
      real    deltaz                                ! zfree - z (m)         
      integer levhi_0                               ! For altitude interpolation
      integer levlow_0                              ! For altitude interpolation
      real    levweight_0                           ! For altitude interpolation
      integer l,j                                   ! Iteration
     
      ! Local Variables 
            
      
      integer, parameter :: N=45                    ! Number of altitudes layer for slope wind model
      real z(0:N)                                   ! Altitudes of slope winds model levels (m)
      real sheight(0:dimlevs)                       ! GCM levels altitudes (sheight_0 with value 0m for index 0)


         
      real :: p_gcm(dimlevs)                        ! Pressure at GCM levels (Pa)
      real :: temp_gcm_pot(0:dimlevs)               ! Potential temperature at GCM levels (K)
     
      real :: theta(0:N)                            ! Potential temperature at slope winds model levels (K)      
      real :: theta0(0:N)                           ! Reference potential temperature at slope winds model levels (K) 
      
      real :: dtdz(0:N)                             ! d(theta0)/dz at slope winds model levels (K/m)
      
              

      ! Variables/Csts for friction , buoyancy and Coriolis
             
      real pkv(0:N)                                 ! Eddy coefficient at slope winds model mid levels (m2/s) 
      real u_star				    ! Friction velocity to compute pKv (m/s)
      real e_turb(0:N)                              ! Turbulent kinetic energy to compute pKv (m2/s2)
      
      real dz(0:N)                                  ! Altitude difference between two slope winds model levels (m)
      real Kv(0:N)                                  ! pKv at slope winds model levels (m2/s) 
      real K(0:N)                                   ! Kv/dz (m/s)      
     
      real a(0:N)                                   ! buoyancy term (m/s2/K)      
      
      real alpha(2,2,N)                             ! matrix to solve the equation system
      real beta(2,2,N)                              ! matrix to solve the equation system
      real gamma(2,N)                               ! matrix to solve the equation system
      real C(2,0:N)                                 ! matrix to solve the equation system
      real D(2,2,0:N)                               ! matrix to solve the equation system 
      real X(2,0:N)                                 ! vector (u,v)                
      real lambda(2,2)                              ! Inverse matrix of alpha-beta*D
         
      real f                                        ! Coriolis parameter (s-1)
            
      ! Constants/var
      
      real rcp                                      ! R/Cp                                    
      integer ih                                    ! iteration
      
      real alpha_b                                  ! Coefficient for buoyancy term          
      real zmin                                     ! minimum value for zfree_0 (m)
      real lmin                                     ! Mixing length constant (m)

      real zmax                                     ! maximum value for zfree_0 (m)    
      integer i_zmax                                ! index of z corresponding to zmax        
      integer i_zmax1(1)                            ! index of z corresponding to zmax too   
      
      
      real    pi,degtorad                           ! Constants
      parameter (pi=3.14159265358979d0)
      parameter (degtorad=pi/180.0d0)
      
      real, parameter ::  emin = 1.e-6              ! Minimal turbulent kinetic energy (m2/s2)
      real, parameter :: g = 3.73                   ! acceleration of gravity (m/s2)
      real, parameter :: kappa = 0.4                ! Von Karman constant
      

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                  Defining some constants                           !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

      
      f =  sin(degtorad*lati)*4*pi/(88775.3) ! 0. ! Coriolis coefficient
      rcp = rgas/cp                               ! Ratio R/Cp
            
      
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                  Parameters of the model                           !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!      
      
      lmin      = 80. ! 70. ! 71. ! 41.   ! 71. ! 30. ! 99. ! 49. ! 43. ! 8.                                 ! Mixing length
      alpha_b   = 1 ! 1 ! 100. ! 6. ! 100. ! 11.   ! 100. ! 6. ! 4.1 ! 3.9 !2.1 ! 3
      zlim      = 300.	
      u_star    = 0.7 ! 30. !35. ! 21.    ! 35. ! 1.5 !2.1 ! 2.6 ! 4.1 ! 4.6 ! 15.      
      zmin      = 300. ! 750. ! 1000. ! 750. ! 500. ! 9500. ! 5000. ! 4500. ! 5000.
      
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                  Altitudes of the model                            !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      
      
      ! Altitudes for slope winds model
      
      z(0) = 0
            
      do l = 1,N
       z(l) = z(l-1) + (zlim-z(0))/N
      enddo
         
      
      z =(/0.,0.1,0.2,0.4,0.7,1.,1.50,2.1,3.,5.,8.,12.,18.,27.,40.,70.,100.,200.,300.,    &
           400.,500.,600.,700.,800.,900.,1000.,1100.,1200.,1300.,1400.,1500.,1600.,1700., & 
           1800.,1900.,2000.,2100.,2200.,2300.,2400.,2500.,2600.,2700.,2800.,2900.,3000./)   
      
      !do l =15,N
      ! z(l) = z(l-1) + (zlim-z(14))/(N-14)
      !enddo 
      
      !do l =1,N
      ! write(27,*) z(l)
      ! write(*,*) l,z(l)
      !enddo
      !stop
      
      
      !z = (/0.,5.,10.,20.,50.,100.,200.,500.,1000.,2000.,3000./)
            
      ! Altitudes for GCM model
      
      sheight(0) = 0.

      do l = 1,dimlevs
       sheight(l) = sheight_0(l)
      enddo 
      
      

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     Definition of reference vertical profile for potential temperature theta0        ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      
      
      
      ! Potential temperature of GCM on GCM levels
                
      p_gcm = ps_hr * sigma
      
      do l = 1,dimlevs
         temp_gcm_pot(l) = temp_gcm(l)*(ps_hr/p_gcm(l))**rcp
      enddo
      
      temp_gcm_pot(0) = (temp_gcm_pot(1)*sheight(2)-temp_gcm_pot(2)*sheight(1))/(sheight(2)-sheight(1))

       
      ! Potential temperature of GCM on slope winds model levels (linear interpolation) 
            
      theta(0) = temp_gcm_pot(0) !Tsurf ! temp_gcm_pot(1) ! Tsurf  ! 240.
            
      do l = 1,N
                              
       do j=0,dimlevs-1
                        
        if ((z(l).ge.sheight(j)).and.(z(l).lt.sheight(j+1))) then
              	     
         levhi_0=j+1
         levlow_0=j
         levweight_0=(z(l)-sheight(levlow_0))/(sheight(levhi_0)-sheight(levlow_0))
                 
        endif
	
       enddo      

       theta(l) = temp_gcm_pot(levlow_0)+(temp_gcm_pot(levhi_0)-temp_gcm_pot(levlow_0))*levweight_0
     
      enddo
     
      
      
      !h_conv = conv_height
      !if(h_conv.lt.zmin) h_conv = zmin 

      !zfree_0 = h_conv*sin(theta_s*degtorad)

      
      if (theta(0).lt.theta(1)) then      
       zfree_0 = 40.
       !i_zmax1 = maxloc(theta)    
       !i_zmax = i_zmax1(1)
       !zmax = z(i_zmax-1)
       !zfree_0 = zmax 
      else
       i_zmax1 = minloc(theta)    
       i_zmax = i_zmax1(1)
       zmax = z(i_zmax-1)
       zfree_0 = zmax              
      endif
  
      
      
      
      !zfree_0 = zmin*sin(theta_s*degtorad)
     
      do l = 0,N 
       
       if (z(l).lt.zlim) then
        deltaz = -(zfree_0/zlim)*z(l) + zfree_0
       else
        deltaz = 0.
       endif
                 
       zfree = z(l) + deltaz
                
       do j=1,N-1
                 
        if ((zfree.ge.z(j)).and.(zfree.lt.z(j+1))) then
              	     
         levhi_0=j+1
         levlow_0=j
         levweight_0=(zfree-z(levlow_0))/(z(levhi_0)-z(levlow_0))
                 
        endif        
       
       enddo
             
       theta0(l) = theta(levlow_0)+(theta(levhi_0)-theta(levlow_0))*levweight_0

       if(zfree.ge.z(N)) theta0(l) = theta(N)
            
      enddo
      
      
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!               Calculation of derivative of theta0 : d(theta0)/dz                     ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      
      
      ! Euler method for dtheta0/dz from theta0 profile
      
      dtdz(0) = (theta(1)-theta(0))/(z(1)-z(0))  
           
      do l = 1,N-1
       dtdz(l) = ((theta(l+1)-theta(l-1))/2.)/((z(l+1)-z(l-1))/2.)
      enddo    
    
      dtdz(N) = dtdz(N-1) 
      
      
      
      ! If negative (instable atmosphere, mostly by day) we set to zero 
      
      !do l =0,N
      ! if (dtdz(l).lt.0.) dtdz(l)=-dtdz(l) !
      !enddo
      
      !do l =0,N
      ! dtdz(l) = max(dtdz(l),0.005)
      !enddo      
      
      
      
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!               Definition of Eddy turbulent vertical coefficient K                    ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
     
       
      ! K coefficient at slope winds model levels
        
      do l=0,N       
       pKv(l) =  u_star*kappa*z(l)/((1+kappa*z(l)/lmin))**2   ! 50.   
      enddo
      
      do l=0,N   
       if(z(l).eq.0) then
        e_turb(l) =  emin
       else 
       e_turb(l) = max(((kappa*z(l))/(1+kappa*z(l)/lmin))**2*((u_star/(kappa*z(l)))**2-0*g/theta(l)*dtdz(l)),emin)
     
       endif

       pKv(l)   = kappa*z(l)/(1+kappa*z(l)/lmin)*sqrt(e_turb(l))
       
       
      enddo            
      
      
      ! K coefficient at semi slope winds model levels (l+1/2)


      Kv(0) = pKv(0)
     
      do l=1,N       
       Kv(l) = (pKv(l-1)+pKv(l))/2.       
      enddo 
            
      
      ! Definition useful variable as K/dz
      
      do l=1,N       
       K(l)  = Kv(l)/(z(l)-z(l-1))       
      enddo 
      



      
      
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!         Definition of useful variables for solving equations system                  ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  

      do l=1,N
       
       a(l) = alpha_b*g/theta0(l)*sin(degtorad*theta_s)

      enddo
      
      
      
      do l=1,N-1
       dz(l) = (z(l+1)-z(l-1))/2.
      enddo
              
      dz(N) = dz(N-1)
      
                
      
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!         Boundary conditions of our problem at z=0 and z=zlim                         !
!         X(0)=(u(0),v(0),theta'(0))  and X(N) =  (u(N),v(N),theta'(N))                ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
    
            

      ! At z = 0, u=0,v=0,theta' = [theta0(0) - theta0(zfree)]*coeff        
      ! where zfree = Hpbl*sin(alpha) with alpha the slope inclination
       
             
      
      ! We limit Hpbl to zmin since during night Hpbl goes to zero 
      
      X(:,0) = (/0.,0./)
     

     
      ! At z = zlim, u=0,v=0,theta'=0
      
      X(:,N) = (/0.,0./)    
      
      

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!         Solving the sytem written under matrix form as :                              ! 
!         alpha(l)*X(l) = beta(l+1/2)*X(l+1)+beta(l-1/2)*X(l-1)                         !
!                                                                                       !
!         We use the formula : X(l) = C(l+1) + D(l+1)X(l+1)                             ! 
!                                                                                       !
!  Initializing C(1) = X(0) and D(1) = 0 , one can calculate C(l) and D(l) for all l    ! 
!  Then, knowing X(N), one can deduce X(l) for all l                                    !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




      ! Defintion of matrix alpha(l) and beta(l)
           
      do l=1,N-1
              
       alpha(1,:,l) = (/K(l+1)+K(l), -f*dz(l)/)
       alpha(2,:,l) = (/f*dz(l)    , K(l+1)+K(l)/)
      
      enddo
      
      do l=1,N
      
       beta(1,:,l)  = (/K(l),   0.  /)
       beta(2,:,l)  = (/0.  ,   K(l)/)
       
      enddo
      
      do l=1,N
      
       gamma(1,l)  = a(l)*(theta(l)-theta0(l))*dz(l)
       gamma(2,l)  = 0.
       
      enddo      

      
      ! Initializing C(1) and D(1) from X(0)      

             
      C(:,1)   = X(:,0)
      D(:,1,1) = (/0.,0./)
      D(:,2,1) = (/0.,0./)  
            

      ! Calculation of C(l) and D(l) for all l (from bottom to top)
           
      do l=1,N-1       
                                                                                  
       call matinv2(alpha(:,:,l)-matmul(beta(:,:,l),D(:,:,l)), lambda)
                
       C(:,l+1)   = matmul(lambda,matmul(beta(:,:,l),C(:,l))+gamma(:,l)) 
       D(:,:,l+1) = matmul(lambda,beta(:,:,l+1))
                                  
      enddo 
      
      
      ! Deduce X(l) for all l from X(N) (from top to bottom)

          
      do l= 1,N-1
                
       ih = N-l+1

       X(:,ih-1) = C(:,ih) + matmul(D(:,:,ih),X(:,ih))
                             
      enddo 
      
   !   do l = 0,N
   !   write(299,*) z(l), X(1,l), X(2,l),X(3,l), theta0(l), dtdz(l),Kv(l)
   !  &            ,K(l),-dtdz(1)*zfree_0
       
   !   enddo
   !   stop
    


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!        Interpolation of u,v and theta' at zsurface altitude                      ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    

      
      if(zsurface.ge.z(N)) then 
       
       upslope_wind    = 0.
       crossslope_wind = 0.
       temp            = 0. 
      
      else 
       
       do j=0,N-1                        
        
        if ((zsurface.ge.z(j)).and.(zsurface.lt.z(j+1))) then             	     
         
         levhi_0=j+1
         levlow_0=j
         levweight_0=(zsurface-z(levlow_0))/(z(levhi_0)-z(levlow_0))
                 
        endif
	
       enddo          

       upslope_wind    = X(1,levlow_0)+(X(1,levhi_0)-X(1,levlow_0))*levweight_0
       crossslope_wind = X(2,levlow_0)+(X(2,levhi_0)-X(2,levlow_0))*levweight_0
       temp            = (theta(levlow_0)-theta0(levlow_0)) +                    & 
                         ((theta(levhi_0)-theta0(levhi_0))-(theta(levlow_0)-theta0(levlow_0)))*levweight_0
      
      endif
          

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!           Projection of winds on west-east and south-north direction             ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
  
      
      merid_slope_wind = - upslope_wind*cos(psi_s*degtorad)-crossslope_wind*sin(psi_s*degtorad)

      zonal_slope_wind = - upslope_wind*sin(psi_s*degtorad)+crossslope_wind*cos(psi_s*degtorad)
          
           
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine vdif_k(sheight,levhi,levlow,u,v,Temp,Tsurf,P,Psurf,pKv)

      use MCD_var, only : dimlevs, g0

      implicit none
      
      
      real,    intent(in)  :: sheight(dimlevs)  ! altitudes (above surface) of GCM sigma levels (m)
      integer, intent(in)  :: levhi             ! database level, upper bound (wrt sought alt.)
      integer, intent(in)  :: levlow            ! database level, lower bound (wrt sought alt.)
      real,    intent(in)  :: u(dimlevs)        ! Zonal wind (m/s)
      real,    intent(in)  :: v(dimlevs)        ! Meridional wind (m/s)
      real,    intent(in)  :: temp(dimlevs)     ! Temperature (K)
      real,    intent(in)  :: Tsurf             ! Surface Temperature
      real,    intent(in)  :: P(dimlevs)        ! Pressure (Pa)
      real,    intent(in)  :: Psurf             ! Surface Pressure (Pa)

      real,    intent(out) :: pKv(dimlevs)      ! Eddy coefficient (m2/s)

      integer :: l ! iteration        


      real :: zdu(dimlevs),zdv(dimlevs),zdz(dimlevs) ! Delta between 2 level of : zonal, meridional wind et altitude 
      real :: zdvodz2(dimlevs)                       ! Square of derivativetotal wind to altitude  (1/s2)

      real :: rcp                   ! Thermal capacity                               
      real :: T_pot(dimlevs)        ! Potential temperature at Psurf at given level (K)
      real :: T_pot_mid(dimlevs)    ! Potential temperature at Psurf between 2 levels (K)
      real :: dT_pot_dz(dimlevs)    ! Derivative of the potential temperature to altitude (K/m)

      real :: z1(dimlevs)           ! middle altitude between 2 levels (m)
      real :: Ri                    ! Richardson number
 
      real :: lmix(dimlevs),lmixmin ! Mixing length (m)
      real :: emin_turb             ! Turbulent energy (m2/s2)

      real, parameter :: karman=0.4 ! Von Karman constant 


      lmixmin   = 30.
      emin_turb = 1.e-6
      rcp       = 0.259                 ! on considere que gamma = 1.35 avec rcp = (1-gamma)/gamma, ce qui est valable a 3% pres en dessous de 5000m


      ! Computing mixing length in first layer 
      Z1(1) = sheight(1)/2.
      lmix(1) = karman*Z1(1)/(1.+karman*Z1(1)/lmixmin)

      ! Computing derivative of wind to altitude
      
      zdu(1) = u(1)
      zdv(1) = v(1)
      zdz(1) = sheight(1)
      zdvodz2(1) = (zdu(1)**2 + zdv(1)**2)/(zdz(1)**2)
 
      ! Computing derivative of potential temperature to altitude
 
      T_pot(1) = temp(1)*(psurf/P(1))**rcp
      T_pot_mid(1) = (T_pot(1) + Tsurf)/2.
      dT_pot_dz(1) = (T_pot(1) - Tsurf)/zdz(1)

      ! Computing same things in each layer 
      
      do l=2,levhi
         
         ! Computing mixing length
         Z1(l) = (sheight(l) + sheight(l-1))/2.
         lmix(l) = karman*Z1(l)/(1.+karman*Z1(l)/lmixmin)

         ! derivative of wind to altitude
         zdu(l) = u(l) - u(l-1)
         zdv(l) = v(l) - v(l-1)
         zdz(l) = sheight(l) - sheight(l-1)
         zdvodz2(l) = (zdu(l)**2 + zdv(l)**2)/(zdz(l)**2)

         ! derivative of potential temperature to altitude
         T_pot(l) = temp(l)*(psurf/P(l))**rcp
         T_pot_mid(l) = (T_pot(l) + T_pot(l-1))/2.
         dT_pot_dz(l) = (T_pot(l) - T_pot(l-1))/zdz(l)

      enddo
      
      ! Computing Eddy coefficiant function of Richardson number

      do l=1,levhi

         if (zdvodz2(l).lt.1.e-5) then
            pKv(l) = lmix(l)*sqrt(emin_turb)
         else
            Ri = g0 * dT_pot_dz(l) /(T_pot_mid(l)*zdvodz2(l))
            pKv(l) = lmix(l)*sqrt(max(lmix(l)**2*zdvodz2(l),emin_turb))
         endif

      enddo

      end


! CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC          

      subroutine matinv2(A,B)
    
    !! Performs a direct calculation of the inverse of a 2x2 matrix.
    
      real, intent(in)  :: A(2,2)   !! Matrix
      real, intent(out) :: B(2,2)   !! Inverse matrix
      
      
      real  detinv

    ! Calculate the inverse determinant of the matrix
      detinv = 1/(A(1,1)*A(2,2) - A(1,2)*A(2,1))

    ! Calculate the inverse of the matrix
      B(1,1) = +detinv * A(2,2)
      B(2,1) = -detinv * A(2,1)
      B(1,2) = -detinv * A(1,2)
      B(2,2) = +detinv * A(1,1)
      end 
      
      
! CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC


      subroutine read_slope_map(slon,slat,dset,alpha,phi,ier)
      
      
      use netcdf

      use MCD_var, only : out, output_messages
    
!      Reading of the slope map inclination/orientation
      
      implicit none
     
!     Inputs     
      real,          intent(in)  ::  slon  ! longitude where interpolate
      real,          intent(in)  ::  slat  ! latitude where interpolate
      character*(*), intent(in)  ::  dset  ! Dataset

!     Outputs
      real,          intent(out) :: alpha  ! Slope inclination
      real,          intent(out) :: phi    ! Slope orientation      
      integer,       intent(out) :: ier    ! Error 

!     Local variables
      
      integer nid,nvarid,ierr
      integer iloop
      real alpha1(4), phi1(4)
      real n1(3,4),n(3)
      integer latp(4),lonp(4)
      integer yinf,ysup,xinf,xsup,tinf,tsup
      real latinf,latsup,loninf,lonsup
      real colat,dlat,dlon
      real,save :: radeg,pi
      integer :: londim,latdim
      real, dimension(:), allocatable, save :: lat,lon,time
      real, dimension(:,:), allocatable, save :: alpha_map,phi_map
      integer, save :: lonlen,latlen
      character(len=33),save :: filename      

      logical, save  :: firstcall
      data firstcall/.true./


!    Test if  we have changed the dust scenario since last call of call_mcd

      if (firstcall) then
      
      firstcall = .false.
      
      if(allocated(alpha_map)) deallocate(alpha_map)
      if(allocated(phi_map))   deallocate(phi_map)      	
      if(allocated(lon))       deallocate(lon)
      if(allocated(lat))       deallocate(lat)
      
!     If allocated deallocate(lat,lon,time,tautes)
      
       pi=acos(-1.)
       radeg=180/pi
   
       filename = 'slope_map.nc'

!     Opening slope file 

      if(output_messages) then 
        write(out,*) 'Opening ', trim(dset)//trim(filename)
      endif
        
      ierr=nf90_open(trim(dset)//trim(filename),nf90_nowrite,nid)
     
      if (ierr.ne.nf90_noerr) then
       ier = 15   
       if(output_messages) then
         write(out,*) "Error in read_slope_map : cannot open file ",trim(dset)//trim(filename)
       endif
       return
      endif
      
      
!     Load latitude dimension
      
      ierr=nf90_inq_dimid(nid,"latitude",latdim)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*)"Error: reas_slope_map <latitude> not found"
       endif
       return
      endif
      
      ierr=nf90_inquire_dimension(nid,latdim,len=latlen)
      
!     Load longitude dimension
      
      ierr=nf90_inq_dimid(nid,"longitude",londim)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
           write(out,*)"Error: read_slope_map <longitude> not found"
       endif
       return 
      endif
       
      ierr=nf90_inquire_dimension(nid,londim,len=lonlen)


      allocate(alpha_map(lonlen,latlen))
      allocate(phi_map(lonlen,latlen))      
      allocate(lat(latlen), lon(lonlen))
      
!     Load slope inclination
   
      ierr=nf90_inq_varid(nid,"Theta_s_max",nvarid)
      ierr=nf90_get_var(nid,nvarid,alpha_map)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_slope_map <alpha> not found"
        write(out,*) trim(nf90_strerror(ierr))        
       endif
       return
      endif
            
!     Load slope orientation
   
      ierr=nf90_inq_varid(nid,"psi_s_max",nvarid)
      if(ierr.ne.nf90_noerr) write(*,*) nf90_strerror(ierr)
      ierr=nf90_get_var(nid,nvarid,phi_map)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_slope_map <phi> not found"
        write(out,*) trim(nf90_strerror(ierr))        
       endif
       return
      endif      
           
!     Get values of latitude   

      ierr=nf90_inq_varid(nid,"latitude",nvarid)
      ierr=nf90_get_var(nid,nvarid,lat)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_slope_map <latitude> not found"
        write(out,*) trim(nf90_strerror(ierr))
       endif
       return
      endif
           
!     Get values of longitude   

      ierr=nf90_inq_varid(nid,"longitude",nvarid)
      ierr=nf90_get_var(nid,nvarid,lon)
      if (ierr.ne.nf90_noerr) then
       ier = 16
       if(output_messages) then
        write(out,*) "Error: read_slope_map <longitude> not found"
        write(out,*) trim(nf90_strerror(ierr))
       endif
       return
      endif
      
      ierr=nf90_close(nid)   

      endif ! of if (firstcall)
            
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!          Bilinear interpolation at desired point                    c
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


!     Find the four nearest points, arranged as follows:
!                               1 2
!                               3 4

!     Find encompassing latitudes
      
      if (slat<(lat(1))) then ! between north pole and lat(1)
       ysup=1
       yinf=1
      else if (slat>=lat(latlen)) then ! between south pole and lat(laten)
       ysup=latlen
       yinf=latlen
      else ! general case
      do iloop=2,latlen
         if(slat<lat(iloop)) then
           ysup=iloop
           yinf=iloop-1
           exit
         endif
      enddo
      endif
      
      latinf=lat(yinf)
      latsup=lat(ysup)

!     Find encompassing longitudes
!     Note: in input file, lon(1)=-180.
      if (slon>lon(lonlen)) then
       xsup=1
       xinf=lonlen
       loninf=lon(xsup)
       lonsup=180.0 ! since lon(1)=-180.0
      else
      do iloop=2,lonlen         
         if(slon<=lon(iloop)) then
              xsup=iloop
              xinf=iloop-1
              exit
         endif
      enddo
      loninf=lon(xinf)
      lonsup=lon(xsup)
      endif

      if ((xsup.gt.lonlen).or.(yinf.gt.latlen).or.(xinf.lt.1).or.(ysup.lt.1)) then
       ier = 16
       if(output_messages) then
        write (out,*) "read_slope_map : SYSTEM ERROR on x or y"
        write (out,*) "xinf: ",xinf
        write (out,*) "xsup: ",xsup
        write (out,*) "yinf: ",yinf
        write (out,*) "ysup: ",ysup
       endif
       return
      endif



!     The four neighbouring points are arranged as follows:
!                               1 2
!                               3 4

      latp(1)=ysup
      latp(2)=ysup
      latp(3)=yinf
      latp(4)=yinf

      lonp(1)=xinf
      lonp(2)=xsup
      lonp(3)=xinf
      lonp(4)=xsup      

      
!     Bilinear interpolation on the four nearest points

      if ((slat<lat(1)).OR.(slat>lat(latlen)).OR.(latsup==latinf)) then
       dlat=0
      else
      dlat=(slat-latinf)/(latsup-latinf)
      endif

      if (lonsup==loninf) then
       dlon=0
      else
       dlon=(slon-loninf)/(lonsup-loninf)
      endif


!     Spatial Interpolation

      if ((dlat>1).OR.(dlon>1) .OR. (dlat<0) .OR. (dlon<0)) then
       ier = 16
       if(output_messages) then
        write (out,*) "read_dust_scenario: SYSTEM ERROR on dlat or dlon"
        write (out,*) "dlat: ",dlat
        write (out,*) "lat: ",slat
        write (out,*) "dlon: ",dlon
        write (out,*) "lon: ",slon
       endif
       return
      endif
      
      do iloop = 1,4
      
       alpha1(iloop) = alpha_map(lonp(iloop),latp(iloop))/radeg
       phi1(iloop) = phi_map(lonp(iloop),latp(iloop))/radeg
       
       n1(:,iloop) = (/sin(alpha1(iloop))*sin(phi1(iloop)),sin(alpha1(iloop))*cos(phi1(iloop)),cos(alpha1(iloop))/)
     
       n1(:,iloop) = n1(:,iloop)/sqrt(sum(n1(:,iloop)**2))
       
      enddo  
      
      n = dlat*(dlon*(n1(:,2)+n1(:,3)-n1(:,1)-n1(:,4))+n1(:,1)-n1(:,3)) +dlon*(n1(:,4)-n1(:,3))+n1(:,3)
               
      n = n/sqrt(sum(n**2))
      
      alpha = atan2(sqrt(1-n(3)**2),sqrt(n(3)**2))*radeg
      phi   = atan2(n(1),n(2))*radeg  
             
      end
      

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine mola(dset,latitude,longitude,alt,ierr)
!Give the MOLA altitude (alt), given lat and lon coordinates
!Using bilinear interpolation from 32 pixels/degree MOLA file
!
!  12/2016 swiched some internal computations to double precision EM.
!

      use netcdf
      
      use MCD_var, only : out, output_messages

      implicit none

! Arguments
! inputs
      character*(*), intent(in)  :: dset      ! Path to MCD datafiles 
      real,          intent(in)  :: latitude  ! north latitude (degrees)
      real,          intent(in)  :: longitude ! east longitude (degrees)
! outputs
      real,          intent(out) :: alt       ! above areoid altitude of surface (meters)
      integer,       intent(out) :: ierr      ! returned status code (==0 if OK)

! Local variables

      logical firstcall
      data firstcall/.true./
      save firstcall
      character*140 molafile ! MOLA datafile 
!      data molafile/'mola_32.2.nc'/
!      data molafile/'mola16.nc'/
!      data molafile/'mola32.nc'/
      double precision resol
!      parameter(resol=16) ! MOLA pixel/degree resolution
      parameter(resol=32)
!      real invresol
!      parameter(invresol=1./resol)
      integer jjm, iim   ! # of longitude and latitude MOLA data values
      parameter(jjm=180*resol, iim=2*jjm)
      integer*2 altmola(iim,jjm) ! MOLA altitude dataset
      save altmola

      integer*2 mintopo_check,maxtopo_check ! known min and max of MOLA dataset
!      parameter(mintopo_check=-8156,maxtopo_check=21191) ! mola_32.2.nc
!      parameter(mintopo_check=-8177,maxtopo_check=21191) ! mola16.nc
      parameter(mintopo_check=-8206,maxtopo_check=21191) ! mola32.nc
      double precision dlat, dlon ! , lontmp
      integer i,j ! ,count
      double precision topo(4) ! neighboring MOLA points (for bilinear interpolation)
      integer latsup,latinf,loninf,lonsup ! indexes of neighboring points
      integer*2 mintopo, maxtopo ! min and max of read dataset
      integer nid,nvarid ! NetCDF file and variable IDs
      double precision colat ! colatitude
      double precision lat,lon ! longitude and latitude, local values (in degrees)

! 1. Load MOLA dataset upon first call
!    (dataset is stored in a 'save' array)

      if (firstcall) then
         firstcall=.false.

! 1.1. Open MOLA file
         molafile=dset//'mola32.nc'
         if (output_messages) then
           write(out,*)"Loading MOLA topography from file ",trim(molafile)
         endif
         ierr = nf90_open (molafile, nf90_nowrite,nid)
         if (ierr.NE.nf90_noerr) then
            if (output_messages) then
              write(out,*)"Error in mola: Could not open file ",trim(molafile)
            endif
            ierr=15 !set appropriate error code
            return
         endif

! 1.2. Load data
         ierr = nf90_inq_varid (nid, "alt", nvarid)
         ! note that MOLA "alt" are given as "short" (16 bits integers)
         ierr = nf90_get_var(nid, nvarid, altmola)
         if (ierr.ne.nf90_noerr) then
           if (output_messages) then
            write(out,*)"Error in mola: <alt> not found"
           endif
           ierr=16 ! set appropriate error code
           return
         endif


! 1.3. Close MOLA file
         ierr=nf90_close(nid)

! 1.4 Check that the MOLA dataset was correctly loaded

         mintopo=mintopo_check
         maxtopo=maxtopo_check
         do i=1,iim
            do j=1,jjm
               mintopo=min(mintopo,altmola(i,j))
               maxtopo=max(maxtopo,altmola(i,j))
            enddo
         enddo
         if ((mintopo.ne.mintopo_check).or.(maxtopo.ne.maxtopo_check)) then
           if (output_messages) then
            write(out,*)"***ERROR Mola file ",molafile," is not well read"
            write(out,*) "Minimum found: ", mintopo
            write(out,*) "Minimum should be:",mintopo_check
            write(out,*) "Maximum found: ", maxtopo
            write(out,*) "Maximum should be:",maxtopo_check
           endif
           ierr=16
           return
         endif
         if (output_messages) then
           write(out,*) "Done reading MOLA data"
         endif
      endif ! End of if(firstcall)

! 2. Check that input longitude and latitude make sense
      lat=latitude
      if((lat.gt.90).or.(lat.lt.-90)) then
        if (output_messages) then
          write(out,*)"Error in mola: Wrong value for latitude"
        endif
        stop
      endif

! longitude must range from 0 to 360
      lon=longitude
      do while(lon.gt.360.)
        lon=lon-360.
      enddo
      
      do while(lon.lt.0.)
        lon=lon+360.
      enddo
      
! 3. Identify the four neighboring points from MOLA dataset
!    These points are arranged as follows:  1 2
!                                           3 4

      colat=90-lat

      if (colat.lt.1./(2.*resol)) then
         latsup=1 
         latinf=1
         dlat=0
      else if (colat.gt.180.-1./(2.*resol)) then
         latsup=jjm
         latinf=jjm
         dlat=0
      else
         latsup=1+int((colat-1./(2.*resol))*resol)
         latinf=latsup+1
         dlat=1-(colat-(1./(2.*resol)+(latsup-1)/resol))*resol
      endif
      ! handle cases where dlat is slightly out of range due to roundoffs
      if ((dlat.lt.0).and.(dlat.ge.-1.e-5)) dlat=0
      if ((dlat.gt.1).and.(dlat.le.1.00001)) dlat=1.      
! Note: dlat is the (normalized) "latitudinal distance" to point 3 
!       ie: dlat=0 if lat=latitude of point 3
!           dlat=1 if lat=latitude of point 1

      if ((lon.lt.1./(2.*resol)).or.(lon.ge.(360-1./(2.*resol)))) then
         loninf=iim
         lonsup=1
         if (lon.lt.1./(2.*resol)) then
            dlon=lon*resol+0.5
         else
            dlon=(lon-(1./(2.*resol)+(loninf-1)/resol))*resol
         endif
      else
         if (((lon-1./(2.*resol))*resol).ge.0) then
            loninf=1+int((lon-1./(2.*resol))*resol)
         else
            loninf=int((lon-1./(2.*resol))*resol)
         endif
         lonsup=loninf+1
         dlon=(lon-(1./(2.*resol)+(loninf-1)/resol))*resol
      endif
      ! handle cases where dlon is slightly out of range due to roundoffs
      if ((dlon.lt.0).and.(dlon.ge.-1.e-5)) dlon=0
      if ((dlon.gt.1).and.(dlon.le.1.00001)) dlon=1.
! Note: dlon is the (normalized) "longitudinal distance" to point 3
!       ie: dlon=0 if lon=longitude of point 3
!           dlon=1 if lon=longitude of point 4

      if((dlat.gt.1).or.(dlon.gt.1).or.(dlat.lt.0).or.(dlon.lt.0)) then
        if (output_messages) then
         write(out,*)"Error in mola: on dlat or dlon" 
         write(out,*) "dlat: ",dlat
         write(out,*) "lat: ",lat
         write(out,*) "dlon: ",dlon
         write(out,*) "lon: ",lon
        endif
        ierr=-5
        return
      endif

! 4. Interpolation

! Four nearest points are aranged as follows:  1 2
!                                              3 4
      topo(1)=dble(altmola(loninf,latsup))
      topo(2)=dble(altmola(lonsup,latsup))
      topo(3)=dble(altmola(loninf,latinf))
      topo(4)=dble(altmola(lonsup,latinf))
   
! Use bilinear interpolation to evaluate alt

      alt=(1.-dlon)*(1.-dlat)*topo(3)+(1.-dlat)*dlon*topo(4)+dlat*(1.-dlon)*topo(1)+dlat*dlon*topo(2)

      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

        subroutine molareoid(dset,lon,lat,rareoid)
! This subroutine returns the radial position (ie: distance to the center
! of Mars) of the reference areoid for a given position (given values of
! longitude and latitude)
! Based on "areoid.f" program by G. Neumann, which is available at
! ftp://ltpftp.gsfc.nasa.gov/projects/tharsis/MOLA/SOFTWARE/
! uses the gravity field coefficients file 'mgm1025' available in
! the same ftp directory

        use MCD_var, only : out, output_messages

        
        implicit none
                
! inputs:
        character*(*), intent(in)  :: dset    ! path to datafiles
        real,          intent(in)  :: lon     ! East longitude (degrees)
        real,          intent(in)  :: lat     ! North latitude (degrees)
! output:
        real,          intent(out) :: rareoid ! distance (in m) of areoid to center of Mars
        
! COMMON: (shared with readcs.F and geoid.F)
        integer ndeg,ndeg2,nd2p3
        parameter (ndeg=90,ndeg2=2*ndeg,nd2p3=ndeg2+3)
! data structure of gravity field
        double precision v0,omega,ae,gm
        double precision clm(0:ndeg,0:ndeg),slm(0:ndeg,0:ndeg)
        common /gmm1/v0,omega,ae,gm,clm,slm
        integer lmin,lmax
        double precision root(nd2p3)
        double precision requator
        common /sqr/ lmin,lmax,root,requator

        double precision dlon    ! double precision version of lon
        double precision dlat    ! double precision version of lat
        double precision dareoid ! double precision version of rareoid
!        double precision pi,d2r
!        parameter (pi=3.141592653589792D0, d2r=pi/180.d0)
        character*140 mgm     ! gravity field coefficients file
!        data mgm /'mgm1025'/
        integer llmax
        data llmax /50/
! flag for coefficients' initialization
        logical firstcall
        data firstcall /.true./
        
        if (firstcall) then
! initialize gravity coefficients
          lmax = llmax        
          ! build datafile path+name
          mgm=dset//'mgm1025'
          call readcs(mgm) ! read coefficients from file
          
          if((lmax.le.0).or.(lmax.gt.ndeg)) then
           if (output_messages) then
            write(out,*)'MOLAREOID Error: Gravity file in wrong format!'
            write(out,*)' lmin,max=',lmin,lmax
           endif
           stop
          endif
        firstcall=.false.
        endif ! of if (firstcall)

        dlon=dble(lon)
        dlat=dble(lat)
        call geoid(dlon,dlat,dareoid)
        rareoid=real(dareoid)
        
        end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

        subroutine readcs(mgm)

        use MCD_var, only : out, output_messages

        implicit none

! input
        character*(*), intent(in) ::  mgm ! file to read coefficients from

         character*64 title ! first line of file
         character*6 gcoef
! data structure of gravity field
         integer ndeg,ndeg2,nd2p3
          parameter (ndeg=90,ndeg2=2*ndeg,nd2p3=ndeg2+3)
          double precision c(0:ndeg,0:ndeg),s(0:ndeg,0:ndeg)
          double precision  v0,omega,ae,gm !,clm,slm
          double precision  plm(ndeg)
          common /gmm1/ v0,omega,ae,gm,c,s
          integer lmin,lmax
          double precision root(nd2p3)
          double precision r
          common /sqr/ lmin,lmax, root,r
!
        integer lcmax,mmax
        integer k,l,m
        double precision coef
        double precision x,xi,sum
        
          ae= 3396000.d0
          gm =42828.37d9
          omega=0.70882181d-4
! this value makes the equatorial mean radius equal to 3396 km.
        do k=1,nd2p3
         root(k)=sqrt(dble(k))
        enddo
!  initialize
        do l=0, ndeg
         do m=0,l
          c(l,m)=0.
          s(l,m)=0.
         enddo
        enddo
        open(unit=11,file=mgm,status='old',err=999)
        if (output_messages) then
          write(out,*)'Loading gravity field coefficients from file ',trim(mgm)
        endif 
!        write(*,'(a,a)')' GCOEF potential model: ',mgm
        read (11,'(a)') title
!        write(out,*) title
        read (11,1000) gcoef,lcmax,mmax,gm,ae
!        write(out,*) gcoef,lcmax,mmax,gm,ae
!        write(out,*)
1        continue
        read(11,1000,end=99) gcoef,l,m,coef
1000   format(a6,8x,i3,i3,d24.14,d15.9)

!        read(1,1000,end=99) l,m,clm,slm
!1000   format(6x,i3,i3,1p,2d18.9)
        if(l.lt.0 .or. m.lt.0 .or. l.gt.ndeg .or. m.gt.l) goto 999
        if(gcoef.eq.'GCOEFC') c(l,m)=coef
        if(gcoef.eq.'GCOEFS') s(l,m)=coef
!        c(l,m)=clm
!        s(l,m)=slm
        goto 1
99        continue
        close(unit=11)
        r = 3396000.d0 !  MOLA potential surface
        xi = ae/r
        m=0
        x=0.
        sum=0.
        call lgndr(lmax,m,x,plm,root)
        do l=2, lmax
          sum = sum + c(l,m) *xi**l *plm(l-m+1)
        enddo
        sum = sum+1.
! centrifugal potential        
        v0=(gm*sum/r + 0.5*omega**2 * r**2)
!        write(out,*)'v0=', v0
        return

999        continue
        if (output_messages) then
         write(out,*)'READCS Error: file not found or incorrect data',lmax
         write(out,*)'title: ',title
         write(out,*)'gcoef,lcmax,mmax,gm,ae:',gcoef,lcmax,mmax,gm,ae
        endif
        end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

        subroutine geoid(dlon,dlat,rg)
! marsgeoid.f
! calculate radii of surface of constant gravity potential on rotating body
! given spherical harmonic potential of body at lat,lon,elevation
!
! W = V +Phi = gm/r [1+ (R/r)**n [harmonics]] -1/2 omega**2 r**2

        implicit none

        double precision, intent(in)  :: dlon,dlat
        double precision, intent(out) :: rg
        
        double precision pi,d2r
        parameter (pi=3.141592653589792D0, d2r=pi/180.d0)
! data structure of gravity field
        integer ndeg,ndeg1,ndeg2,nd2p3
        parameter (ndeg=90,ndeg1=ndeg+1,ndeg2=2*ndeg,nd2p3=ndeg2+3)
        double precision v0,omega,ae,gm
        double precision c(0:ndeg,0:ndeg),s(0:ndeg,0:ndeg)
        common /gmm1/v0,omega,ae,gm,c,s
        integer lmin,lmax
        double precision root(nd2p3)
        double precision r
        common /sqr/ lmin,lmax,root,r
        double precision plm(ndeg1)
        double precision tol
        data tol /0.125d0/  ! tolerence on computed value of rg

        integer i,m,l
        double precision rlon,rlat
        double precision x,cslt,xi,sum,cslm
        double precision diff
! save r
        rg = r

        rlon=dlon*d2r
        rlat=dlat*d2r
        x = sin(rlat)
        cslt= cos(rlat)

!        csln= cos(rlon)
!        snln= sin(rlon)

         do i=1,8 ! usually 3 iterations suffice

          xi = ae/r
          sum = 0.
          do m=0, lmax
           call lgndr(lmax,m,x,plm,root)
           do l=m, lmax
             cslm =  c(l,m)*cos(m*rlon) + s(l,m)*sin(m*rlon)
             sum = sum + cslm*xi**l *plm(l-m+1)
           enddo
          enddo
          sum=sum+1.
! centrifugal potential        
          rg=(gm*sum+0.5*(omega**2)*(r**3)*(cslt**2))/v0
!          write(out,*) i,r,rg
          diff = r-rg
          r = rg
          if( abs(diff).lt. tol) goto 400
        enddo ! do i=1,8

 400        continue
!        write(*,500) dlon,dlat,r
!500        format(2f9.2, f12.3)
        end

!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      SUBROUTINE LGNDR(LMAX,M,X,PLM,SQR)
! Return vector of plm's of degree from m to lmax, for order m
      implicit none
      
      integer,          intent(in)  :: LMAX
      integer,          intent(in)  :: M
      
      double precision, intent(out) :: X
      double precision, intent(out) :: PLM(*),SQR(*)
      
      integer IFACT,I,LL
      double precision OM, PMM, PMMP1, PLL, SOMX2
!  needs sqrt of integers from 1 to 2*L+3
!  SIGN MODIF. OF NUM.REC. ALGORITHM, TO MATCH GEOPHYS. CONVENTION.
!  AND NORMALIZATION TO MEAN SQUARE UNITY.

      PMMP1=0 !dummy initialization to get rid of compiler warnings

      OM = 1.
      PMM=SQR(2*M+1)
      IF(M.gt.0) then
        PMM=SQR(2)*PMM
        SOMX2=SQRT((1.-X)*(1.+X))
        IFACT=1
        do I=1,M
          OM=-OM
          PMM=-PMM*(SQR(IFACT)/SQR(IFACT+1))*SOMX2
          IFACT=IFACT+2
        enddo
      ENDIF
      PLM(1)=OM*PMM
      if(LMAX.gt.M) then
        PMMP1=X*SQR(2*M+3)*PMM
        PLM(2)=OM*PMMP1
      endif
      if (LMAX.gt.M+1) then
         DO LL=M+2,LMAX
           PLL=SQR(2*LL+1)*SQR(2*LL-1)/(SQR(LL+M)*SQR(LL-M))*(X*PMMP1-PMM*SQR(LL+M-1)*SQR(LL-M-1)/(SQR(2*LL-1)*SQR(2*LL-3)))
           PLM(LL-M+1)=OM*PLL
           PMM=PMMP1
           PMMP1=PLL
         ENDDO
      endif
      END

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
      subroutine julian(month,day,year,hour,minute,second,ierr,date)


      implicit none
!
!     Given Earth date and time compute and local time on Mars
!     Updated version by B. Dolla and F. Forget, 2005
!     Inputs
!
      integer,intent(in)  :: month   
      integer,intent(in)  :: day
      integer,intent(in)  :: year
      integer,intent(in)  :: hour       !All Earth GMT values
      integer,intent(in)  :: minute
      integer,intent(in)  :: second
!
!     Output
!
      integer,intent(out) :: ierr       !0 if ok >0 if there is a problem
      real*8, intent(out) :: date       !Julian date
!
!     Local
!
      integer nday
      integer daynumber(12)   !days for months of the year
      data    daynumber/0,31,59,90,120,151,181,212,243,273,304,334/
      integer jul
      integer j
!
!     Check ranges
!
      ierr=0
      if ((month.lt.1).or.(month.gt.12)) then
        ierr=1
        return
      endif
      if ((day.lt.1).or.(day.gt.31)) then
        ierr=2
        return
      endif
      if (year.lt.1) then
        ierr=3
        return
      endif
      if ((hour.lt.0).or.(hour.gt.23)) then
        ierr=4
        return
      endif
      if ((minute.lt.0).or.(minute.gt.59)) then
        ierr=5
        return
      endif
      if ((second.lt.0).or.(second.gt.60)) then
        ierr=6
        return
      endif
!
!     Calculate Julian date
!
      nday=daynumber(month)+day-1
!
!     Correct for leap year
!     We use the followings conventions
!     GREGORIAN CALENDAR: a year is bissextil if it is a multiple
!     of 4 but not of 100 or if it is a multiple of 400.
!     JULIAN CALENDAR: a year is bissextil if it is a multiple of 4
!
!     The JULIAN calendar ends on the 4th october 1582
!     The GREGORIAN calendar begins on the 15th october 1582
!     Hence there are 10 days missing... e.g. the 10th october 1582 does not exist!!
!

      jul=0
      IF (year.LT.1582) jul=1
      IF ((year.EQ.1582).AND.(month.LT.10)) jul=1
      IF ((year.EQ.1582).AND.(month.EQ.10).AND.(day.LT.15)) jul=1
      
      IF (jul.EQ.0) THEN
         IF ((mod(year,4).EQ.0).AND.(mod(year,100).NE.0).AND.(month.GT.2)) nday=nday+1
         IF ((mod(year,400).EQ.0).AND.(month.GT.2)) nday=nday+1
      ENDIF
      IF (jul.EQ.1) THEN
         IF ((mod(year,4).EQ.0).AND.(month.GT.2)) nday=nday+1
         nday=nday+10
      ENDIF
!
!     We use 1968 as a year of reference, the julian date being 2.4398565d6
!
      IF (year.GT.1968) THEN
         DO j=1968,year-1,1
            nday=nday+365
            IF ((mod(j,4).EQ.0).AND.(mod(j,100).NE.0)) nday=nday+1
            IF (mod(j,400).EQ.0) nday=nday+1
         ENDDO
      ENDIF

      IF (year.LT.1968) THEN
         jul=1
         DO j=year,1967,1
            IF (j.GT.1581) jul=0
            IF (jul.EQ.0) THEN
               nday=nday-365
               IF ((mod(j,4).EQ.0).AND.(mod(j,100).NE.0)) nday=nday-1
               IF (mod(j,400).EQ.0) nday=nday-1
            ENDIF
            IF (jul.EQ.1) THEN
               nday=nday-365
               IF (mod(j,4).EQ.0) nday=nday-1
            ENDIF
         ENDDO
      ENDIF
!
!     Compute Julian date
!
      date=2.4398565d6+nday
      date=date+hour/24.0d0+minute/1.440d3+second/8.6400d4
!
      return
      end

!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


      end module MCD


