#==========================================================================
#			   Copyright (c) 1995 Martien Verbruggen
#			   Copyright (c) 1996 Commercial Dynamics Pty Ltd
#			   Copyright (c) 1997 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GIFgraph::area.pm
#
# $Id: area.pm,v 2.2 1998/08/14 01:53:48 mgjv Exp mgjv $
#
#==========================================================================

package GIFgraph::area;
 
use strict qw(vars refs subs);

use GIFgraph::axestype;

@GIFgraph::area::ISA = qw( GIFgraph::axestype );

{
	# PRIVATE
	sub draw_data { # GD::Image, \@data

		my $s = shift;		# object reference
		my $g = shift;		# gd object reference
		my $d = shift;		# reference to data set

		my $ds;
		foreach $ds (1..$s->{numsets}) 
		{
			my $num = 0;

			# Select a data colour
			my $dsci = $s->set_clr( $g, $s->pick_data_clr($ds) );

			# Create a new polygon
			my $poly = new GD::Polygon();

			# Add the first 'zero' point
			my ($x, $y) = $s->val_to_pixel(1, 0, $ds);
			$poly->addPt($x, $y);

			# Add the data points
			my $i;
			for $i (0 .. $s->{numpoints}) 
			{
				next if (!defined($$d[$ds][$i]));

				($x, $y) = $s->val_to_pixel($i + 1, $$d[$ds][$i], $ds);
				$poly->addPt($x, $y);

				$num = $i;
			}

			# Add the last zero point
			($x, $y) = $s->val_to_pixel($num + 1, 0, $ds);
			$poly->addPt($x, $y);

			# Draw a filled and a line polygon
			$g->filledPolygon($poly, $dsci);
			$g->polygon($poly, $s->{acci});

			# Draw the accent lines
			for $i (1 .. ($s->{numpoints} - 1)) 
			{
				next if (!defined($$d[$ds][$i]));

				($x, $y) = $s->val_to_pixel($i + 1, $$d[$ds][$i], $ds);
				$g->dashedLine( $x, $y, $x, $s->{zeropoint}, $s->{acci} );
		   }
		}
	}

} # End of package GIFgraph::area
 
1;
