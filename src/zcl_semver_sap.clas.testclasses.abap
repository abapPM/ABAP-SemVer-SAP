CLASS ltcl_tests_semver_sap DEFINITION FOR TESTING RISK LEVEL HARMLESS
  DURATION SHORT FINAL.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_semver_sap.

    METHODS:
      setup,
      sap_release_to_semver FOR TESTING RAISING cx_abap_invalid_value,
      sap_release_sp_to_semver FOR TESTING RAISING cx_abap_invalid_value,
      cvers_to_semver FOR TESTING RAISING cx_abap_invalid_value,
      semver_to_sap_release FOR TESTING RAISING cx_abap_invalid_value,
      semver_to_sap_release_sp FOR TESTING RAISING cx_abap_invalid_value.

ENDCLASS.

CLASS ltcl_tests_semver_sap IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD sap_release_to_semver.

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( '750' )
      exp = '7.5.0' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( '75E' )
      exp = '7.5.14' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( '1809' )
      exp = '18.9.0' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( '2011_1_731' )
      exp = '2011.1.731' ).

  ENDMETHOD.

  METHOD sap_release_sp_to_semver.

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( release = '750' support_pack = '0012' )
      exp = '7.5.0-12' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( release = '75E' support_pack = '2' )
      exp = '7.5.14-2' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( release = '1809' support_pack = '0000000001' )
      exp = '18.9.0-1' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->sap_release_to_semver( release = '2011_1_731' support_pack = '0012' )
      exp = '2011.1.731-12' ).

  ENDMETHOD.

  METHOD cvers_to_semver.

    SELECT * FROM cvers INTO TABLE @DATA(cvers).

    " Try to convert all cvers entries. If this fails, open an issue in the GitHub repository
    LOOP AT cvers ASSIGNING FIELD-SYMBOL(<cvers>).
      mo_cut->sap_release_to_semver( <cvers>-release ).
      mo_cut->sap_release_to_semver( release = <cvers>-release support_pack = <cvers>-extrelease ).
    ENDLOOP.

  ENDMETHOD.

  METHOD semver_to_sap_release.

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->semver_to_sap_release( '7.5.0' )
      exp = '750' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->semver_to_sap_release( '7.5.14' )
      exp = '75E' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->semver_to_sap_release( '18.9.0' )
      exp = '1809' ).

    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->semver_to_sap_release( '2011.1.731' )
      exp = '2011_1_731' ).

  ENDMETHOD.

  METHOD semver_to_sap_release_sp.

    DATA:
      release      TYPE cvers-release,
      support_pack TYPE cvers-extrelease.

    mo_cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '7.5.0-12'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    cl_abap_unit_assert=>assert_equals(
      act = release
      exp = '750' ).
    cl_abap_unit_assert=>assert_equals(
      act = support_pack
      exp = '0000000012' ).

    mo_cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '7.5.14-2'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    cl_abap_unit_assert=>assert_equals(
      act = release
      exp = '75E' ).
    cl_abap_unit_assert=>assert_equals(
      act = support_pack
      exp = '0000000002' ).

    mo_cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '18.9.0-1'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    cl_abap_unit_assert=>assert_equals(
      act = release
      exp = '1809' ).
    cl_abap_unit_assert=>assert_equals(
      act = support_pack
      exp = '0000000001' ).

    mo_cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '2011.1.731-12'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    cl_abap_unit_assert=>assert_equals(
      act = release
      exp = '2011_1_731' ).
    cl_abap_unit_assert=>assert_equals(
      act = support_pack
      exp = '0000000012' ).

    " No sp given
    mo_cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '7.5.0'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    cl_abap_unit_assert=>assert_equals(
      act = release
      exp = '750' ).
    cl_abap_unit_assert=>assert_equals(
      act = support_pack
      exp = '0000000000' ).

  ENDMETHOD.

ENDCLASS.
