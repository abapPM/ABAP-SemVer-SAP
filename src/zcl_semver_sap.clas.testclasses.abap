CLASS ltcl_tests_semver_sap DEFINITION FOR TESTING RISK LEVEL HARMLESS
  DURATION SHORT FINAL.

  PRIVATE SECTION.
    DATA tap TYPE REF TO zcl_tap.
    DATA cut TYPE REF TO zcl_semver_sap.

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
    tap = NEW #( ).
    cut = NEW #( ).
  ENDMETHOD.

  METHOD sap_release_to_semver.

    tap->_( cut->sap_release_to_semver( '750' ) )->eq( '7.5.0' ).

    tap->_( cut->sap_release_to_semver( '75E' ) )->eq( '7.5.14' ).

    tap->_( cut->sap_release_to_semver( '1809' ) )->eq( '18.9.0' ).

    tap->_( cut->sap_release_to_semver( '2011_1_731' ) )->eq( '2011.1.731' ).

    tap->_( cut->sap_release_to_semver( '01V_731' ) )->eq( '7.3.1' ).

  ENDMETHOD.

  METHOD sap_release_sp_to_semver.

    tap->_( cut->sap_release_to_semver( release = '750' support_pack = '0012' ) )->eq( '7.5.0-sp.12' ).

    tap->_( cut->sap_release_to_semver( release = '75E' support_pack = '2' ) )->eq( '7.5.14-sp.2' ).

    tap->_( cut->sap_release_to_semver( release = '1809' support_pack = '0000000001' ) )->eq( '18.9.0-sp.1' ).

    tap->_( cut->sap_release_to_semver( release = '2011_1_731' support_pack = '0012' ) )->eq( '2011.1.731-sp.12' ).

    tap->_( cut->sap_release_to_semver( release = '01V_731' support_pack = '0002' ) )->eq( '7.3.1-sp.2' ).

  ENDMETHOD.

  METHOD cvers_to_semver.

    SELECT * FROM cvers INTO TABLE @DATA(cvers).

    " Try to convert all cvers entries. If this fails, open an issue in the GitHub repository
    LOOP AT cvers ASSIGNING FIELD-SYMBOL(<cvers>).
      cut->sap_release_to_semver( <cvers>-release ).
      cut->sap_release_to_semver( release = <cvers>-release support_pack = <cvers>-extrelease ).
    ENDLOOP.

  ENDMETHOD.

  METHOD semver_to_sap_release.

    tap->_( cut->semver_to_sap_release( '7.5.0' ) )->eq( '750' ).

    tap->_( cut->semver_to_sap_release( '7.5.14' ) )->eq( '75E' ).

    tap->_( cut->semver_to_sap_release( '18.9.0' ) )->eq( '1809' ).

    tap->_( cut->semver_to_sap_release( '2011.1.731' ) )->eq( '2011_1_731' ).

  ENDMETHOD.

  METHOD semver_to_sap_release_sp.

    DATA:
      release      TYPE cvers-release,
      support_pack TYPE cvers-extrelease.

    cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '7.5.0-sp.12'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    tap->_( release )->eq( '750' ).
    tap->_( support_pack )->eq( '0000000012' ).

    cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '7.5.14-sp.2'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    tap->_( release )->eq( '75E' ).
    tap->_( support_pack )->eq( '0000000002' ).

    cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '18.9.0-sp.1'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    tap->_( release )->eq( '1809' ).
    tap->_( support_pack )->eq( '0000000001' ).

    cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '2011.1.731-sp.12'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    tap->_( release )->eq( '2011_1_731' ).
    tap->_( support_pack )->eq( '0000000012' ).

    " No sp given
    cut->semver_to_sap_release_sp(
      EXPORTING
        version      = '7.5.0'
      IMPORTING
        release      = release
        support_pack = support_pack ).

    tap->_( release )->eq( '750' ).
    tap->_( support_pack )->eq( '0000000000' ).

  ENDMETHOD.

ENDCLASS.
