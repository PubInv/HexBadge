// Copyright (C) 2026 Robert L. Read
// This program is free software: you can redistribute it and/or 
// modify it under the terms of the GNU Affero General Public 
// License as published by the Free Software Foundation, version 3. 
// This program is distributed in the hope that it will be useful, 
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
// Affero General Public License for more details. You should have
// received a copy of the GNU Affero General Public License along
// with this program. If not, see <https://www.gnu.org/licenses/>.

// Basic Badge Parameters
S_mm = 15; // side of the hexagon
Base_thickness_mm = 2;
Clevis_lug_hole_mm = 1;
Clevis_lug_diameter_mm = 4;
Clevis_lug_thickness_mm = 1;
Clevis_fork_extra_gap_mm = 0.2;
Clevis_lug_added_length_mm = Base_thickness_mm; // Length from bottom of hole to flat base

// Rendering Choice
render_base = 0;
render_holder_unit = 0;

render_pubinv_badge = 1;


// Holder parameters


// Begin code

// Male Clevis Lug (bottom of hole at z = 0)
module MaleClevisLug(add_mm) {
    m = max(add_mm,(Clevis_lug_diameter_mm-Clevis_lug_hole_mm)/2);
    union() {
        translate([0,0, 
        (add_mm + Clevis_lug_hole_mm/2)])
        difference() {
            union() {
                rotate([90,0,0]) 
                cylinder(r=Clevis_lug_diameter_mm/2, 
                    h=Clevis_lug_thickness_mm, $fn=100, center=true);
                translate([0,0,-(m + Clevis_lug_hole_mm/2)/2])
                cube([Clevis_lug_diameter_mm,
                    Clevis_lug_thickness_mm,    
                    m+Clevis_lug_hole_mm/2],center=true); 
            }
            rotate([90,0,0]) 
            cylinder(r=Clevis_lug_hole_mm/2, h=Clevis_lug_thickness_mm*3, $fn=100, center=true); 
        }              
    }
}
// This places the bottom of the whole at z = 0
module FemaleClevisFork() {
    translate([0,Clevis_lug_thickness_mm + Clevis_fork_extra_gap_mm/2,0])
    MaleClevisLug(0);
    translate([0,-(Clevis_lug_thickness_mm+ Clevis_fork_extra_gap_mm/2),0])
    MaleClevisLug(0);    
}

module BasePlate() {
    rotate([0,0,60])
    difference() {
        cylinder(r=S_mm, h=Base_thickness_mm, $fn=6,center=true);
        // Now cut the center hole
        cylinder(h=Base_thickness_mm*3, r=S_mm/3, center = true, $fn=6
        );        
    }
}

module Base() {
    rotate([180,0,0])
    union() {
    BasePlate();
    // Add male Clevis lugs
    d = S_mm*(2/3);
    z = Base_thickness_mm/2;
    translate([d,0,z])
        MaleClevisLug(Clevis_lug_added_length_mm);
    translate([-d,0,z])
        MaleClevisLug(Clevis_lug_added_length_mm);
      }  
}


module HolderUnit() {
    rotate([180,0,0])
    union() {
        // Add female Clevis forks
        d = S_mm*(2/3);
        z = Base_thickness_mm/2;
        translate([d,0,z])
            FemaleClevisFork();
        translate([-d,0,z])
            FemaleClevisFork(); 
        difference() {
            BasePlate();
            translate([d,0,z])
            cube([Clevis_lug_diameter_mm+ Clevis_fork_extra_gap_mm,
                Clevis_lug_thickness_mm + Clevis_fork_extra_gap_mm,       
                Base_thickness_mm*3],center=true);
            translate([-d,0,z])
            cube([Clevis_lug_diameter_mm+ Clevis_fork_extra_gap_mm,
                Clevis_lug_thickness_mm + Clevis_fork_extra_gap_mm,       
                Base_thickness_mm*3],center=true);
        }   
    }
}

// Begin rendering
if (render_base) {
   translate([0,0,Base_thickness_mm+1])
   Base();
}

if (render_holder_unit) {
    HolderUnit();
}
// badges
module BadgeTrim() {
   cylinder(r=S_mm, h=Base_thickness_mm*20, $fn=6,center=true);
}
module PubInvBadge() {
    intersection() {
        s = 0.02;
        rotate([0,0,90])
        translate([0,0,1])
        scale([s,s,s])
        scale([1, 1, 0.8]) {
            surface(file = "LogoPubInv_4x_TouchUp_TwoColor.png", center = true, invert = false);
        }
        BadgeTrim();
    }
    Base();
}

if (render_pubinv_badge) {
    translate([0,0,Base_thickness_mm+1])
    PubInvBadge();  
}

//MaleClevisLug(0);
//FemaleClevisFork();


