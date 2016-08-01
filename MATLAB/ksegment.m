function img_clusters = ksegment(img,k)

%img ==  INPUT IMAGE
%k == number of clusters

dimensions = size(img);
originalRows = dimensions(1,1);
originalColumns = dimensions(1,2);

%image matrix converted to vector
img_vec = img(:);
vec_dimensions = size(img_vec);
vec_size = vec_dimensions(1,1);


%number of features(one right now as just intensity based segmentation)
numfeatures = length(img_vec(1,:));

%number of total pixels of image
numpixels = length(img_vec(:,1));



% initialising centroids randomly
min_intensity = min(img_vec);
max_intensity = max(img_vec);
intensity_diff = max_intensity - min_intensity;
% centroid's matrix - every row  - one cenrtoid
centroids = ones(k, numfeatures) .* rand(k,numfeatures);
for i=1 : 1 : length(centroids(:,1))
  centroids( i , : ) =   centroids( i , : )  .* intensity_diff;
  centroids( i , : ) =   centroids( i , : )  + min_intensity;
end
% centroids initialised to random



% not stopping at start (if we use the while implementation)
pos_diff = 1.;
assign = [];

%disp('before while');

%while pos_diff > 0.0
for inc = 1: 10;
  
  pixelcluster = [];
  % assign each pixel to the closest centroid
  for d = 1 : length( img_vec(:, 1) );

    min_diff = ( img_vec( d, :) - centroids( 1,:) );
    min_diff = min_diff * min_diff';
    clusterAssigned = 1;
    

    for c = 2 : k;
      diff2c = ( img_vec( d, :) - centroids( c,:) );
      diff2c = diff2c * diff2c';
      if( min_diff >= diff2c)
        clusterAssigned = c;
        min_diff = diff2c;
      end
    end

    % assign the d-th dataPoint
    pixelcluster = [ pixelcluster; clusterAssigned];

  end

  
  % for the stoppingCriterion
  oldCentroids = centroids;

  % update
  % recalculate the positions of the centroids
  centroids = zeros(k, numfeatures);
  numPixelsInCluster = zeros(k, 1);

  temp = uint16(centroids);
  for d = 1: length(pixelcluster);
    temp( pixelcluster(d),:) =temp( pixelcluster(d),:)+ uint16(img_vec(d,:));
    numPixelsInCluster( pixelcluster(d), 1 ) = numPixelsInCluster( pixelcluster(d), 1 ) + 1;
  end
  %disp(temp);
  for c = 1: k;
    if( numPixelsInCluster(c, 1) ~= 0)
      temp( c , : ) = temp( c, : ) / numPixelsInCluster(c, 1);
    else
      % set cluster randomly to new position
      temp( c , : ) = (rand( 1, numfeatures) .* intensity_diff) + min_intensity;
    end
  end
  centroids = uint8(temp);
  %stoppingCriterion
 % pos_diff = sum (sum( (centroids - oldCentroids).^2 ) );

  assign = pixelcluster;
  %disp(centroids)
end

for d = 1: numpixels;
 c = assign(d);
 centroidIntensity =centroids(c,:);
 img_vec(d,:) = centroidIntensity;
end

img_clusters = reshape(img_vec,originalRows, originalColumns); 
%functions end
end
