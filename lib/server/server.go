package server

import (
	"context"

	google_pb "github.com/golang/protobuf/ptypes/empty"
	"github.com/slysmoke/static-data/lib/locations"
	pb "github.com/slysmoke/static-data/lib/staticData"
	"github.com/slysmoke/static-data/lib/types"
)

// Server is the gRPC server of this service
type Server struct{}

// GetLocations returns location info for a given list of location IDs
func (server *Server) GetLocations(context context.Context, request *pb.GetLocationsRequest) (*pb.GetLocationsResponse, error) {
	return locations.GetLocations(context, request)
}

// GetMarketTypes returns all market type IDs from cache
func (server *Server) GetMarketTypes(context context.Context, empty *google_pb.Empty) (*pb.GetMarketTypesResponse, error) {
	return types.GetMarketTypes(context, empty)
}
