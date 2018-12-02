#' Save data to a NetCDF file
#'
#' @param data 
#' @param res \code{numeric}. Resolution of the output file.
#' @param ext \code{extent}. If present the NetCDF file is subset by this extent.
#' @param years \code{numeric}. Years which should be written to file.
#' @param names \code{character}. Names of the variables.
#' @return A raster stack with monthly layers of aggregated data over the specified time period and area.
#' @examples
#' @export writeNC
#' @name writeNC
writeNC <- function(data, res, ext, years,
                    names){
  # Set-up dimensions from res and extent
  
  #Define the dimensions
  dimX = ncdim_def(name="lon", units="degrees", vals=seq(-179.75, 179.75, length = 720))
  dimY = ncdim_def(name="lat", units="degrees", vals=seq(-89.75, 89.75, length = 360))
  dimT = ncdim_def(name="time", units="years since 1661-1-1 00:00:00", 
                   vals=c(years-1661), calendar="proleptic_gregorian")
  
  # Define names for NetCDF file, 
  # only needed if multiple variables are required
  names <- paste0("bio", 1:19)
  
  vard <- lapply(names, function(name){
    ncvar_def(name, units="", list(dimX,dimY,dimT), 1.e+20, 
              prec="double", compression=9)})
  
  # Create the NetCDF file
  # if you want a NetCDF4 file, add force_v4=T
  nc <- nc_create(filename, vard)
  
  # In case names are provided run loop, else only single command!
  if(n)
  
  # Individually write data for every species
  for(j in 1:length(names)){
    # Get data
    data <- get(load(dat))
    data <- data %>% dplyr::select(x, y, names[j])
    
    #Expand dataframe with NAs
    df_spat <- expand.grid(x=seq(-179.75, 179.75, length = 720), 
                           y=seq(-89.75, 89.75, length = 360))
    data <- dplyr::left_join(df_spat, data) %>% dplyr::select(-x, -y); rm(df_spat)
    
    # Turn data into array
    data <- array(unlist(data),dim=c(720, 360, ncol(data)), 
                  dimnames=list(NULL, NULL, names(data)))
    
    # Write data to the NetCDF file
    ncvar_put(nc, vard[[j]], data, start=c(1,1,1), count=c(-1,-1,-1))
  }
  # Close your new file to finish writing
  nc_close(nc)
}