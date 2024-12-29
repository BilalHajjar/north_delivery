import 'package:delivary/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:delivary/presentation/admin/store/controller/add_store_controller.dart';
import 'package:delivary/presentation/admin/store/model/list_model.dart';

class RegionComboBox extends StatefulWidget {
  const RegionComboBox({super.key, required this.controller, this.region});
  final AddStoreController controller;
  final ListModel? region;

  @override
  State<RegionComboBox> createState() => _RegionComboBoxState();
}

class _RegionComboBoxState extends State<RegionComboBox> {
  @override
  void initState() {
    super.initState();
    if (widget.region != null) {
      for (int i = 0; i < widget.controller.regionsList.length; i++) {
        if (widget.controller.regionsList[i].id == widget.region!.id) {
          widget.controller.selectedRegion = widget.controller.regionsList[i];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ListModel>(
          value: widget.controller.selectedRegion,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          alignment: AlignmentDirectional.centerStart, // محاذاة مع RTL
          items: widget.controller.regionsList.map((region) {
            return DropdownMenuItem<ListModel>(
              value: region,
              child: Directionality(     textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ Icon(Icons.location_city, color: AppColors.primaColor, size: 18),
                    SizedBox(width: 10),
                    Text(
                      region.name!,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),


                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (ListModel? newValue) {
            setState(() {
              widget.controller.selectedRegion = newValue;
            });
          },
          hint: Text(
            'اختر مدينة',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }
}
